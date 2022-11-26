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

class MyNotification1 {}

class MyNotification2 {}

class MyNotification3 {}

class _MyHomePageState extends State<MyHomePage>{
  var l1 = KINotificationListener<MyNotification1>(onNotification: (notification) {
    print("lll1");
  });

  var l2 = KINotificationListener<MyNotification2>(onNotification: (notification) {
    print("lll2");
  });

  var l3 = KINotificationListener<MyNotification3>(onNotification: (notification) {
    print("lll3");
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification"),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: () {
              KINotificationCenter.instance.handle(l1);
            },
            child: Text("Handle MyNotification1"),
          ),
          TextButton(
            onPressed: () {
              KINotificationCenter.instance.remove(l1);
            },
            child: Text("Remove MyNotification1"),
          ),
          TextButton(
            onPressed: () {
              KINotificationCenter.instance.dispatch(MyNotification1());
            },
            child: Text("Dispatch MyNotification1"),
          ),
          Divider(),
          TextButton(
            onPressed: () {
              KINotificationCenter.instance.handle(l2);
            },
            child: Text("Handle MyNotification2"),
          ),
          TextButton(
            onPressed: () {
              KINotificationCenter.instance.remove(l2);
            },
            child: Text("Remove MyNotification2"),
          ),
          TextButton(
            onPressed: () {
              KINotificationCenter.instance.dispatch(MyNotification2());
            },
            child: Text("Dispatch MyNotification2"),
          ),
          Divider(),
          TextButton(
            onPressed: () {
              KINotificationCenter.instance.handle(l3);
            },
            child: Text("Handle MyNotification3"),
          ),
          TextButton(
            onPressed: () {
              KINotificationCenter.instance.remove(l3);
            },
            child: Text("Remove MyNotification3"),
          ),
          TextButton(
            onPressed: () {
              KINotificationCenter.instance.dispatch(MyNotification3());
            },
            child: Text("Dispatch MyNotification3"),
          ),
          Divider(),
          TextButton(
            onPressed: () {
              KINotificationCenter.instance.removeAll();
            },
            child: Text("Remove All"),
          ),
        ],
      ),
    );
  }
}
