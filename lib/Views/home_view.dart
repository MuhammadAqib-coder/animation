import 'package:animation_task/Views/flutter_switch_animation.dart';
import 'package:animation_task/Views/hero_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  var imageList = [
    'assets/child1.png',
    'assets/child2.png',
    'assets/child3.jpg'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Flutter Animation")),
        body: Column(
          children: [
            Expanded(
              child: GridView.builder(
                  itemCount: imageList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // showDialog(
                        //     context: context,
                        //     builder: (context) {
                        //       return Hero(

                        //           tag: imageList[index],
                        //           child: Image.asset(imageList[index]));
                        //     });
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                                reverseTransitionDuration:
                                    const Duration(milliseconds: 500),
                                transitionDuration: const Duration(seconds: 1),
                                pageBuilder: (_, __, ___) {
                                  return HeroAnimation(image: imageList[index]);
                                }));
                      },
                      child: Hero(
                        tag: imageList[index],
                        child: Card(
                          child: SizedBox(
                            height: 100.h,
                            width: 100.w,
                            child: Image.asset(imageList[index]),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            Hero(
              tag: 'button',
              // transitionOnUserGestures: true,
              flightShuttleBuilder: (flightContext, animation, flightDirection,
                  fromHeroContext, toHeroContext) {
                return FadeTransition(
                  opacity: animation,
                  // .drive(Tween(begin: 0.0, end: 1.0)
                  //     .chain(CurveTween(curve: Curves.linear))),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black.withOpacity(0.2)),
                    child: Container(),
                  ),
                );
              },
              child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () {
                    Navigator.push(context, _createRoute());
                  },
                  child: const Text(
                    'switcher animation',
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          content: Lottie.asset('assets/animation/success.json',
                              height: 200.h,
                              width: 300.w,
                              animate: true,
                              repeat: false),
                        );
                      });
                },
                child: const Text(
                  'Lottie animation',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ));
  }

  _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondAnimation) {
        return const FlutterSwitchAnimation();
      },
      transitionDuration: const Duration(seconds: 1),
      reverseTransitionDuration: const Duration(seconds: 1),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0, 1);
        const end = Offset.zero;
        const curve = Curves.linear;

        final tween = Tween(begin: begin, end: end);
        final curvedAnimation =
            CurvedAnimation(parent: animation, curve: curve);
        // final offsetAnimation = animation.drive(tween);
        return FadeTransition(
          opacity: curvedAnimation,
          child: child,
        );
      },
    );
  }
}
