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
      title: 'State View',
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
  String state = "default";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("State View"),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            if (state == "default") {
              state = "loading";
              setState(() {});
            } else if (state == "loading") {
              state = "done";
              setState(() {});
            }
          },
          child: KIStateView(
            state: state,
            states: const [
              KIStateViewState(
                "default",
                child: Text(
                  "提交",
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
                size: Size(200, 50),
                textStyle: TextStyle(color: Colors.white, fontSize: 18),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                clipBehavior: Clip.hardEdge,
              ),
              KIStateViewState(
                "loading",
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.white,
                  ),
                ),
                size: Size(50, 50),
                textStyle: TextStyle(color: Colors.white, fontSize: 18),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
              ),
              KIStateViewState(
                "done",
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: Icon(
                    Icons.done,
                    color: Colors.white,
                  ),
                ),
                size: Size(50, 50),
                textStyle: TextStyle(color: Colors.white, fontSize: 18),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
              ),
            ],
            onStateChanged: (value) {
              print("state changed: $value");

              if (value == "done") {
                Future.delayed(const Duration(seconds: 2), () {
                  state = "default";
                  setState(() {});
                });
              }
            },
          ),
        ),
      ),
    );
  }
}
