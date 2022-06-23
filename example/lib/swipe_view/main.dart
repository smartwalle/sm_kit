import 'package:flutter/material.dart';
import 'package:sm_kit/sm_kit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swipe View',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Swipe View"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            KISwipeView(
              direction: KISwipeDirection.ltr,
              end: 0.7,
              front: (ctr) {
                return Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.redAccent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () {
                          ctr.open();
                        },
                        child: const Text("open"),
                      ),
                    ],
                  ),
                );
              },
              back: (ctr) {
                return Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.greenAccent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () {
                          ctr.close();
                        },
                        child: const Text("close"),
                      ),
                    ],
                  ),
                );
              },
            ),
            KISwipeView(
              direction: KISwipeDirection.rtl,
              front: (ctr) {
                return Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.redAccent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          ctr.open();
                        },
                        child: const Text("open"),
                      ),
                    ],
                  ),
                );
              },
              back: (ctr) {
                return Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.greenAccent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          ctr.close();
                        },
                        child: const Text("close"),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
