import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class PullToRefreshPage extends StatefulWidget {
  const PullToRefreshPage({Key? key}) : super(key: key);

  @override
  State<PullToRefreshPage> createState() => _PullToRefreshPageState();
}

class _PullToRefreshPageState extends State<PullToRefreshPage> {
  final controller = ScrollController();
  List data = [
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
  ];
  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        load();
      }
    });
  }

  Future<void> load() async {
    await Future.delayed(Duration(milliseconds: 1200));
    setState(() {
      data.addAll([
        '9999',
        '9999',
        '9999',
        '9999',
        '9999',
        '9999',
        '9999',
        '9999',
        '9999',
        '9999',
      ]);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  data = data.sublist(0, 11);
                });
              },
              icon: Icon(Icons.close))
        ],
      ),
      body: Column(
        children: [
          const Text('Data'),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                controller: controller,
                itemExtent: 100.0,
                itemCount: data.length + 1,
                itemBuilder: (context, index) {
                  if (index < data.length) {
                    return Card(
                      color: Colors.lightBlue,
                      child: Center(child: Text(data[index])),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
          )
        ],
      ),
    );
  }
}
