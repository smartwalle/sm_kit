import 'dart:math';

import 'package:example/swipe_controller/transition_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sm_kit/sm_kit.dart';
import 'package:sm_router/sm_router.dart';

void main() {
  KIRouter.handle("/", (ctx) => const Home());
  KIRouter.handle("/page2", (ctx) => const Page2());

  KIRouter.setPageBuilder((ctx, child) => FadeTransitionPage(child: child));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routeInformationParser: KIRouter.routeInformationParser,
      routerDelegate: KIRouter.routerDelegate,
      scrollBehavior: AppScrollBehavior(),
    );
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late final KISwipeController swipe = KISwipeController(
    this,
    () {
      KIRouter.push("/page2");
    },
    behavior: KISwipeBehavior.bottomToTop,
    threshold: 300,
  );

  @override
  Widget build(BuildContext context) {
    return swipe.wrapGestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Swipe Controller"),
        ),
        body: swipe.buildListener(builder: (value, tapDown, __) {
          // value = min(0.2 + value, 1);
          return Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: value * 100,
                child: Hero(
                  tag: "bg",
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: Colors.amberAccent,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: value * 100,
                child: Align(
                  alignment: Alignment.center,
                  child: Hero(
                    tag: "text",
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 80,
                          fontWeight: FontWeight.normal,
                          textBaseline: TextBaseline.alphabetic,
                        ),
                        text: "Something",
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    swipe.dispose();
    super.dispose();
  }
}

class Page2 extends StatefulWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> with SingleTickerProviderStateMixin {
  late final KISwipeController swipe = KISwipeController(
    this,
    () {
      KIRouter.pop();
    },
    behavior: KISwipeBehavior.topToBottom,
  );

  @override
  Widget build(BuildContext context) {
    return swipe.wrapGestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Page2"),
        ),
        body: swipe.buildListener(builder: (value, _, __) {
          return Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: value * 100 + 100,
                child: Align(
                  alignment: Alignment.center,
                  child: Hero(
                    tag: "bg",
                    child: Container(
                      width: 400,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.amberAccent,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: value * 100,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.center,
                  child: Hero(
                    tag: "text",
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 80,
                          fontWeight: FontWeight.normal,
                          textBaseline: TextBaseline.alphabetic,
                        ),
                        text: "Something",
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    swipe.dispose();
    super.dispose();
  }
}
