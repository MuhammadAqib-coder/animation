import 'package:animation_task/Views/animation_pkg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

import 'package:lottie/lottie.dart';

class AnimationWithTween extends StatefulWidget {
  const AnimationWithTween({super.key});

  @override
  State<AnimationWithTween> createState() => _AnimationWithTweenState();
}

class _AnimationWithTweenState extends State<AnimationWithTween>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late AnimationController boxController;
  late Animation colorAnimation;
  late Animation sizeAnimation;
  var newColor = const Color.fromARGB(255, 33, 150, 243);
  var _sliderValue = 0.0;
  var angle = 0.0;
  var boxDecoration = DecorationTween(
      begin: BoxDecoration(
          color: Colors.white,
          border: Border.all(style: BorderStyle.none),
          borderRadius: BorderRadius.circular(60.r),
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                blurRadius: 10.r,
                spreadRadius: 3.r,
                offset: const Offset(0, 6))
          ]),
      end: BoxDecoration(
          color: Colors.white,
          border: Border.all(style: BorderStyle.none),
          borderRadius: BorderRadius.zero));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
        reverseDuration: const Duration(seconds: 1))
      ..repeat(reverse: true);
    colorAnimation =
        ColorTween(begin: Colors.deepPurpleAccent, end: Colors.cyanAccent)
            .animate(controller);
    sizeAnimation = Tween(begin: 50.h, end: 80.h).animate(controller);
    boxController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat(reverse: true);
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    boxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tween Animation'),
        centerTitle: true,
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              height: 20.h,
            ),
            // Center(
            //   child: Container(
            //     height: sizeAnimation.value,
            //     width: sizeAnimation.value,
            //     color: colorAnimation.value,
            //   ),
            // ),
            SizedBox(
              height: 20.h,
            ),
            Center(
              child: TweenAnimationBuilder(
                  tween: ColorTween(begin: Colors.blue, end: newColor),
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOutCubic,
                  builder: (context, value, child) {
                    return Container(
                      height: 100.h,
                      width: 100.w,
                      color: value,
                    );
                  }),
            ),
            Slider.adaptive(
                value: _sliderValue,
                onChanged: (value) {
                  setState(() {
                    _sliderValue = value;
                    angle = value;
                    newColor =
                        Color.lerp(Colors.blue, Colors.brown, _sliderValue)!;
                  });
                  if (value == 1) {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            content: Lottie.asset(
                                'assets/animation/success.json',
                                height: 200.h,
                                width: 300.w,
                                animate: true,
                                repeat: false),
                          );
                        });
                  }
                }),
            Center(
              child: TweenAnimationBuilder(
                onEnd: () {},
                tween: Tween(begin: 0, end: angle),
                duration: const Duration(seconds: 1),
                child: Container(
                  height: 100.h,
                  width: 100.w,
                  color: const Color.fromARGB(255, 224, 70, 14),
                ),
                builder: (context, value, child) {
                  return Transform.rotate(
                    angle: -(angle * math.pi * 2),
                    child: child,
                  );
                },
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            Center(
              child: SizedBox(
                height: 100.h,
                child: Center(
                  child: DecoratedBoxTransition(
                      decoration: boxDecoration.animate(boxController),
                      child: Padding(
                        padding: EdgeInsets.all(10.sp),
                        child: const FlutterLogo(),
                      )),
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Hero(
              tag: 'button',
              child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () {
                    Navigator.of(context).push(_createRoute());
                  },
                  child: const Text(
                    'Next',
                    style: TextStyle(color: Colors.white),
                  )),
            )
          ],
        ),
      ),
    );
  }

  _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return const AnimationPkg();
      },
      transitionDuration: const Duration(seconds: 1),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var curveAnimation =
            CurvedAnimation(parent: animation, curve: Curves.linear);
        return FadeTransition(
          opacity: curveAnimation,
          child: child,
        );
      },
    );
  }
}
