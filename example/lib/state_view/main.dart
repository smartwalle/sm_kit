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
  KIViewStateController ctr = KIViewStateController("default");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: GestureDetector(
          onTap: () {
            if (ctr.animationStatus != AnimationStatus.completed) {
              return;
            }
            if (ctr.stateName == "default") {
              ctr.updateState("loading");
            } else if (ctr.stateName == "loading") {
              ctr.updateState("done");
            }
          },
          child: KIStateView(
            controller: ctr,
            states: const [
              KIViewState(
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
              KIViewState(
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
              KIViewState(
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
                  ctr.updateState("default");
                });
              }
            },
          ),
        ),
      ),
    );
  }
}
