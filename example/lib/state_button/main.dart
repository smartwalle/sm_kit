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
  var ctr1 = KIStateController("default");
  var ctr2 = KIStateController("default");

  @override
  Widget build(BuildContext context) {
    print("build.....1");
    return Scaffold(
      appBar: AppBar(
        title: const Text("State Button"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            KIStateButton(
              controller: ctr1,
              states: [
                KIStateButtonState(
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
                    ctr1.state = "loading";
                  },
                ),
                KIStateButtonState(
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
                    ctr1.state = "done";
                  },
                ),
                KIStateButtonState(
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
                    ctr1.state = "default";
                  });
                }
              },
            ),
            KIStateButton.builder(
              controller: ctr2,
              stateBuilder: (nState) {
                switch (nState) {
                  case "loading":
                    {
                      return KIStateButtonState(
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
                        textStyle:
                            const TextStyle(color: Colors.white, fontSize: 18),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        onPressed: () {
                          ctr2.state = "done";
                        },
                      );
                    }
                  case "done":
                    {
                      return KIStateButtonState(
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
                        textStyle:
                            const TextStyle(color: Colors.white, fontSize: 18),
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
                      return KIStateButtonState(
                        "default",
                        child: const Text(
                          "提交",
                          textAlign: TextAlign.center,
                          maxLines: 1,
                        ),
                        size: const Size(200, 50),
                        textStyle:
                            const TextStyle(color: Colors.white, fontSize: 18),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        onPressed: () {
                          ctr2.state = "loading";
                        },
                      );
                    }
                }
              },
              onStateChanged: (value) {
                if (value == "done") {
                  Future.delayed(const Duration(seconds: 2), () {
                    ctr2.state = "default";
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
