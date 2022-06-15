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
  var buttonState = "default";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("State Button"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            KIStateButton(
              state: buttonState,
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
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  onPressed: () {
                    buttonState = "loading";
                    setState(() {});
                  },
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
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  onPressed: () {
                    buttonState = "done";
                    setState(() {});
                  },
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
                  size: const Size(50, 50),
                  textStyle: const TextStyle(color: Colors.white, fontSize: 18),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  onPressed: null,
                ),
              ],
              onStateChanged: (value) {
                if (value == "done") {
                  Future.delayed(const Duration(seconds: 2), () {
                    buttonState = "default";
                    setState(() {});
                  });
                }
              },
            ),
            KIStateButton.builder(
              state: buttonState,
              stateBuilder: (nState) {
                switch (nState) {
                  case "loading":
                    {
                      return KIButtonState(
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
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        onPressed: () {
                          buttonState = "done";
                          setState(() {});
                        },
                      );
                    }
                  case "done":
                    {
                      return KIButtonState(
                        "done",
                        child: const SizedBox(
                          height: 24,
                          width: 24,
                          child: Icon(
                            Icons.done,
                            color: Colors.white,
                          ),
                        ),
                        size: const Size(50, 50),
                        textStyle: const TextStyle(color: Colors.white, fontSize: 18),
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        onPressed: null,
                      );
                    }
                  default:
                    {
                      return KIButtonState(
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
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        onPressed: () {
                          buttonState = "loading";
                          setState(() {});
                        },
                      );
                    }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
