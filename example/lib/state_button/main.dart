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
      title: 'State Button',
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
  KIStateController ctr = KIStateController("default");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("State Button"),
      ),
      body: Center(
        child: KIStateButton(
          controller: ctr,
          states: [
            KIButtonState(
              "default",
              child: const Text(
                "提交",
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
              size: const Size(200, 50),
              textStyle: const TextStyle(color: Colors.white, fontSize: 18),
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
            ),
            KIButtonState(
              "loading",
              child: const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                ),
              ),
              size: const Size(50, 50),
              textStyle: const TextStyle(color: Colors.white, fontSize: 18),
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
            ),
            KIButtonState(
              "done",
              child: const SizedBox(
                height: 24,
                width: 24,
                child: Icon(
                  Icons.done,
                  color: Colors.white,
                ),
              ),
              constraints: const BoxConstraints(minWidth: 50, minHeight: 50, maxWidth: 50, maxHeight: 50),
              textStyle: const TextStyle(color: Colors.white, fontSize: 18),
              decoration: const BoxDecoration(
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
          onPressed: () {
            if (ctr.animationStatus != AnimationStatus.completed) {
              return;
            }
            if (ctr.stateName == "default") {
              ctr.updateState("loading");
            } else if (ctr.stateName == "loading") {
              ctr.updateState("done");
            }
          },
        ),
      ),
    );
  }
}
