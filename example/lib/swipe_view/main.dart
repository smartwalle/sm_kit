import 'package:flutter/gestures.dart';
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

class _HomeState extends State<Home> {
  Map<int, KISwipeViewController> ctrs = <int, KISwipeViewController>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Swipe View"),
      ),
      body: SizedBox(
        child: ListView.builder(
          itemCount: 100,
          itemBuilder: (ctx, index) {
            return KISwipeView(
              onDragStart: (ctr) {
                ctrs.forEach((key, value) {
                  if (value != ctr) {
                    value.close();
                  }
                });
              },
              onStatusChanged: (ctr) {
                if (ctr.status == KISwipeViewStatus.completed) {
                  ctrs.forEach((key, value) {
                    if (value != ctr) {
                      value.close();
                    }
                  });
                  ctrs[index] = ctr;
                }
              },
              backgroundRatio: 0.3,
              direction: KISwipeDirection.rtl,
              foreground: (ctr, animation) {
                var colorAnimation = ColorTween(begin: Colors.red, end: Colors.purple).animate(animation);

                return AnimatedBuilder(
                  animation: animation,
                  builder: (_, __) {
                    return Container(
                      width: double.infinity,
                      height: 100,
                      color: colorAnimation.value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton(
                            onPressed: () {
                              ctr.open();
                            },
                            child: Text("open ${index}"),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              background: (ctr, animation) {
                var widthAnimation = Tween<double>(begin: 0, end: ctr.backgroundWidth).animate(animation);

                return AnimatedBuilder(
                  animation: animation,
                  builder: (BuildContext context, Widget? child) {
                    return Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: widthAnimation.value,
                        height: 300,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                color: Colors.teal,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.lightGreen,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.pinkAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
