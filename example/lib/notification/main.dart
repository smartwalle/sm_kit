import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sm_kit/sm_kit.dart';

void main() {
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

class MyNotification extends KINotification {}

class MyNotification2 extends KINotification {}

class MyNotification3 extends KINotification {}

class _MyHomePageState extends State<MyHomePage> {
  var l1 = KINotificationListener<MyNotification>(onNotification: (notification) {
    print("lll1");
  });

  var l2 = KINotificationListener<MyNotification2>(onNotification: (notification) {
    print("lll2");
  });

  @override
  void initState() {
    super.initState();

    KINotificationCenter.instance.handle(l1);
    KINotificationCenter.instance.handle(l2);
  }

  void _incrementCounter() {
    KINotificationCenter.instance.dispatch(MyNotification());
    KINotificationCenter.instance.dispatch(MyNotification2());
    KINotificationCenter.instance.dispatch(MyNotification3());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scheduler"),
      ),
      body: Center(),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
