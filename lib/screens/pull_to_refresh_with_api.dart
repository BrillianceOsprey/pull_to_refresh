import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PullToRefreshWithApi extends StatefulWidget {
  const PullToRefreshWithApi({Key? key}) : super(key: key);

  @override
  State<PullToRefreshWithApi> createState() => _PullToRefreshWithApiState();
}

class _PullToRefreshWithApiState extends State<PullToRefreshWithApi> {
  List<String> data = [];
  final controller = ScrollController();
  final limit = 25;
  int page = 1;
  bool hasMore = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();

    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        fetchData();
      }
    });
  }

  Future<void> fetchData() async {
    // await Future.delayed(Duration(microseconds: 1200));
    if (isLoading) return;
    isLoading = true;
    final uri =
        'https://jsonplaceholder.typicode.com/posts?_limit=$limit&_page=$page';

    final url = Uri.parse(uri);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List newItems = jsonDecode(response.body);

      setState(() {
        isLoading = false;
        page++;
        data.addAll(newItems.map((e) => 'Data ${[e['id']]}').toList());
        if (newItems.length < limit) {
          hasMore = false;
        }
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  Future onRefresh() async {
    setState(() {
      isLoading = false;
      hasMore = true;
      page = 1;
      data = [];
    });
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  data = data.sublist(0, 8);
                });
              },
              icon: Icon(Icons.close))
        ],
      ),
      body: ListView.builder(
          controller: controller,
          itemCount: data.length + 1,
          itemExtent: 100.0,
          itemBuilder: (context, i) {
            if (i < data.length) {
              return Card(
                color: Colors.lightBlue,
                child: Center(child: Text(data[i])),
              );
            } else {
              return Center(
                child: hasMore
                    ? const CircularProgressIndicator()
                    : const Text('No more data'),
              );
            }
          }),
    );
  }
}
