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
  var h1 = KINotificationHandler<MyNotification1>(onNotification: (notification) {
    print("handler --- 1");
  });

  var h2 = KINotificationHandler<MyNotification2>(onNotification: (notification) {
    print("handler --- 2");
  });

  var h3 = KINotificationHandler<MyNotification3>(onNotification: (notification) {
    print("handler --- 3");
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
              KINotificationCenter.instance.handle(h1);
            },
            child: Text("Handle MyNotification1"),
          ),
          TextButton(
            onPressed: () {
              KINotificationCenter.instance.remove(h1);
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
              KINotificationCenter.instance.handle(h2);
            },
            child: Text("Handle MyNotification2"),
          ),
          TextButton(
            onPressed: () {
              KINotificationCenter.instance.remove(h2);
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
              KINotificationCenter.instance.handle(h3);
            },
            child: Text("Handle MyNotification3"),
          ),
          TextButton(
            onPressed: () {
              KINotificationCenter.instance.remove(h3);
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
