import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _controller;
  final List<int> fibonacci = [0, 1];
  List<List<int>> listCircleItem = [];
  List<List<int>> listSquareItem = [];
  List<List<int>> listCrossItem = [];

  int indexSelect = 0;
  int? indexRemove;

  List<Icon> iconFibonacci = [
    const Icon(Icons.lens),
    const Icon(Icons.crop_square),
    const Icon(Icons.clear),
  ];

  List<int> generateFibonacci(int num) {
    for (int i = 2; i < num; i++) {
      fibonacci.add(fibonacci[i - 1] + fibonacci[i - 2]);
    }

    return fibonacci;
  }

  void filterItem(
    BuildContext context, {
    required int index,
    required int value,
    required List<List<int>> itemList,
  }) {
    bool isCheckRepeat = false;

    itemList.map((e) {
      if (e[0] == index) {
        isCheckRepeat = true;
      }
    }).toList();

    if (!isCheckRepeat) {
      itemList.add([index, value]);
    }

    buildBottomSheet(context, itemList);
  }

  void removeItem({
    required int index,
    required int fibonacci,
  }) {
    indexRemove = index;

    if (fibonacci % 3 == 0) {
      listCircleItem.removeWhere((e) => e[0] == index);
    } else if (fibonacci % 3 == 1) {
      listSquareItem.removeWhere((e) => e[0] == index);
    } else if (fibonacci % 3 == 2) {
      listCrossItem.removeWhere((e) => e[0] == index);
    }

    _controller.animateTo(
      index * 56.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    _controller = ScrollController();
    super.initState();
    generateFibonacci(40);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Example"),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: ListView.builder(
          controller: _controller,
          itemCount: fibonacci.length,
          itemBuilder: (_, index) {
            return Container(
              height: 56,
              color: indexRemove == index ? Colors.red : Colors.white,
              child: ListTile(
                title: Text('Index: $index, Number: ${fibonacci[index]}'),
                trailing: InkWell(
                  child: iconFibonacci[fibonacci[index] % 3],
                  onTap: () async {
                    setState(() {
                      indexRemove = null;
                    });

                    indexSelect = index;
                    if (fibonacci[index] % 3 == 0) {
                      filterItem(
                        context,
                        index: index,
                        value: fibonacci[index],
                        itemList: listCircleItem,
                      );
                    } else if (fibonacci[index] % 3 == 1) {
                      filterItem(
                        context,
                        index: index,
                        value: fibonacci[index],
                        itemList: listSquareItem,
                      );
                    } else if (fibonacci[index] % 3 == 2) {
                      filterItem(
                        context,
                        index: index,
                        value: fibonacci[index],
                        itemList: listCrossItem,
                      );
                    }
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> buildBottomSheet(BuildContext context, List listSelectItem) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: ListView.builder(
            itemCount: listSelectItem.length,
            itemBuilder: (context, index) {
              return Container(
                color: indexSelect == listSelectItem[index][0]
                    ? Colors.green
                    : Colors.transparent,
                child: ListTile(
                  title: Text('Number: ${listSelectItem[index][1]}'),
                  subtitle: Text('Index: ${listSelectItem[index][0]}'),
                  trailing: iconFibonacci[listSelectItem[index][1] % 3],
                  onTap: () {
                    Navigator.pop(context);
                    removeItem(
                      index: listSelectItem[index][0],
                      fibonacci: listSelectItem[index][1],
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
