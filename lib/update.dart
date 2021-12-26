// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Update extends StatefulWidget {
  const Update({Key? key, required this.data}) : super(key: key);
  final dynamic data;

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  TextEditingController nikController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController shiftController = TextEditingController();
  String textError = '';

  updateAction() async {
    setState(() {
      textError = '';
    });
    try {
      Response response = await put(
        Uri.parse("https://rendifajri.com/pm11/public/api/employee/" +
            widget.data['id'].toString()),
        headers: <String, String>{
          "Content-Type": "application/json",
        },
        body: json.encode(<String, String>{
          "nik": nikController.text,
          "password": passwordController.text,
          "name": nameController.text,
          "department": departmentController.text,
          "shift": shiftController.text,
        }),
      ).timeout(const Duration(seconds: 15));
      var body = json.decode(response.body);
      print(jsonDecode(response.body));
      if (body["status"] == "success") {
        Navigator.pop(context);
      } else {
        setState(() {
          body["message"].forEach(
            (k, v) => {
              for (var resLoop in v) {textError += resLoop + '\n'}
            },
          );
          textError = textError.substring(0, textError.length - 2);
        });
      }
    } catch (err) {
      print(err);
      setState(() {
        textError = "Tidak bisa mengakses server";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.data);
    // print("nik " + widget.data["nik"]);
    // print("name " + widget.data["name"]);
    // print("department " + widget.data["department"]);
    // print("shift " + widget.data["shift"]);
    nikController.text = widget.data["nik"];
    nameController.text = widget.data["name"];
    departmentController.text = widget.data["department"];
    shiftController.text = widget.data["shift"];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(0),
              child: Text(
                textError,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                controller: nikController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'NIK',
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                controller: departmentController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Department',
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                controller: shiftController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Shift',
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                ),
              ),
            ),
            Container(
              height: 65,
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: MaterialButton(
                textColor: Colors.white,
                color: Colors.blue,
                child: const Text(
                  'Add',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  updateAction();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
