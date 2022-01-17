// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pm12/update.dart';

import 'create.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  dynamic apiResult = [];
  List<Container> varContainer = [];

  void getData() async {
    final Response response = await get(
      Uri.parse(
          "https://rendifajri.com/pm11/public/api/employee?page=1&limit=100"),
      headers: <String, String>{
        "Content-Type": "application/json",
      },
    );
    var body = await json.decode(response.body);
    print(jsonDecode(response.body));
    varContainer = <Container>[];
    if (body["status"] == "success") {
      apiResult = body["response"];
      // maxPage = int.parse(body["response_total_page"].toString());
      setState(() {
        for (var res in apiResult) {
          varContainer.add(
            Container(
              // height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: Colors.white),
                color: Colors.grey[700],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Text(
                      res["nik"] + " - " + res["name"],
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Update(data: res),
                              ),
                            );
                          },
                          child: Text(
                            'Update',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.blue[300],
                              decoration: TextDecoration.underline,
                              decorationThickness: 3,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            deleteAction(res["id"]);
                          },
                          child: Text(
                            'Delete',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.blue[300],
                              decoration: TextDecoration.underline,
                              decorationThickness: 3,
                            ),
                          ),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.end,
                    ),
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),
          );
        }
      });
    }
  }

  deleteAction(dynamic id) async {
    try {
      Response response = await delete(
        Uri.parse(
            "https://rendifajri.com/pm11/public/api/employee/" + id.toString()),
        headers: <String, String>{
          "Content-Type": "application/json",
        },
      ).timeout(const Duration(seconds: 15));
      // var body = json.decode(response.body);
      print(jsonDecode(response.body));
      getData();
    } catch (err) {
      print(err);
    }
  }

  @override
  void initState() {
    super.initState();
    // getData(page);
    getData();
    Timer.periodic(const Duration(seconds: 5), (timer) {
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(children: varContainer),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Create(),
            ),
          );
        },
        tooltip: "Add Data",
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
