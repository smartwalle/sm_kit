import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sm_kit/sm_kit.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Message {
  late int id;
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _addTask() async {
    for (var i = 0; i < 10; i++) {
      print("添加任务 $i ${DateTime.now()}");
      var m = Message();
      m.id = i;
      KIPriorityThread.instance.scheduleTask<Message, int>((value) {
        sleep(Duration(seconds: 3));
        return value.id * 100;
      }, m, i, () => true).then((value) {
        print("任务完成 $i ${DateTime.now()}");
        setState(() {
          _counter = value;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thread"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            TextButton(onPressed: _addTask, child: Text("添加任务")),
            TextButton(
              onPressed: () {
                KIPriorityThread.instance.maxActive = 1;
              },
              child: Text("MacActive: 1"),
            ),
            TextButton(
              onPressed: () {
                KIPriorityThread.instance.maxActive = 5;
              },
              child: Text("MacActive: 5"),
            ),
          ],
        ),
      ),
    );
  }
}
