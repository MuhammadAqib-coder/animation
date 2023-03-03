import 'dart:math' as math;
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:animation_task/Views/animatedWidgets/button_animation.dart';
import 'package:animation_task/Views/animation_with_tween.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FlutterSwitchAnimation extends StatefulWidget {
  const FlutterSwitchAnimation({super.key});

  @override
  State<FlutterSwitchAnimation> createState() => _FlutterSwitchAnimationState();
}

class _FlutterSwitchAnimationState extends State<FlutterSwitchAnimation>
    with TickerProviderStateMixin {
  var height = 100.h;
  var width = 200.w;
  var colorList = [
    const Color.fromARGB(255, 27, 143, 31),
    const Color.fromARGB(255, 39, 28, 11),
    const Color.fromARGB(255, 240, 232, 159),
    Colors.brown,
    Colors.blueGrey
  ];
  var colorIndex = 0;
  var randomColr;
  var random = math.Random();
  var selected = false;
  late AnimationController buttonController;
  late AnimationController builderControler;
  late AnimationController explicitTransition;
  late final Animation<AlignmentGeometry> _alignAnimation;
  late final Animation<double> _rotationAnimation;
  var _sliderValue = 0.01;
  var rotationWithTween;

  var colorizeColors = [
    Colors.purple,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];

  var colorizeTextStyle = const TextStyle(
    fontSize: 18.0,
    fontFamily: 'Horizon',
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    randomColr = Color.fromRGBO(
        random.nextInt(255), random.nextInt(255), random.nextInt(255), 1);
    builderControler =
        AnimationController(vsync: this, duration: const Duration(seconds: 5))
          ..repeat();
    buttonController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat();
    explicitTransition = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000))
      ..repeat(reverse: true);
    _alignAnimation = Tween<AlignmentGeometry>(
            begin: Alignment.centerLeft, end: Alignment.centerRight)
        .animate(CurvedAnimation(
            parent: explicitTransition, curve: Curves.easeInOutCubic));
    _rotationAnimation = Tween<double>(begin: 0, end: 2).animate(
        CurvedAnimation(
            parent: explicitTransition, curve: Curves.easeInOutCubic));
    rotationWithTween = Tween<double>(begin: 0, end: math.pi * 2).animate(
      builderControler,
    );
    // controller.forward();
    // controller.addStatusListener((status) {
    //   switch (status) {
    //     case AnimationStatus.completed:
    //       controller.reverse();
    //       break;
    //     case AnimationStatus.dismissed:
    //       controller.forward();
    //       break;
    //     case AnimationStatus.forward:
    //       break;
    //     case AnimationStatus.reverse:
    //       break;
    //   }
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    buttonController.dispose();
    builderControler.dispose();
    explicitTransition.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            AnimatedTextKit(
                repeatForever: true,
                isRepeatingAnimation: true,
                animatedTexts: [
                  RotateAnimatedText(
                    'Implicit ',
                  ),
                  RotateAnimatedText(
                    'Explicit ',
                  )
                ]),
            const Text(' Animation'),
          ],
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(10.sp),
        children: [
          SizedBox(
            height: 10.h,
          ),
          Hero(
              transitionOnUserGestures: true,
              tag: 'button',
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
                  child: const Text('hero',
                      style: TextStyle(color: Colors.white)))),
          SizedBox(
            height: 40.h,
          ),
          AnimatedTextKit(
              totalRepeatCount: 1,
              isRepeatingAnimation: true,
              repeatForever: true,
              displayFullTextOnTap: true,

              // stopPauseOnTap: true,
              // displayFullTextOnTap: true,
              animatedTexts: [
                FadeAnimatedText('Animated Switcher'),
                ScaleAnimatedText('Animated Switcher'),
              ]),
          SizedBox(
            height: 10.h,
          ),
          AnimatedSwitcher(
            transitionBuilder: (child, animation) {
              return RotationTransition(
                turns: animation,
                child: child,
              );
            },
            duration: const Duration(milliseconds: 500),
            child: Container(
              key: ValueKey<double>(height),
              height: height,
              width: width,
              decoration: BoxDecoration(
                  color: randomColr, borderRadius: BorderRadius.circular(10.r)),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          AnimatedTextKit(
              repeatForever: true,
              isRepeatingAnimation: true,
              animatedTexts: [
                TypewriterAnimatedText('Animated Widget',
                    speed: const Duration(milliseconds: 100))
              ]),
          ButtonAnimation(
              controller: buttonController,
              onTap: () {
                setState(() {
                  height = random.nextDouble() * 200;
                  width = random.nextDouble() * 200;
                  // colorIndex = random.nextInt(5);
                  randomColr = Color.fromRGBO(random.nextInt(255),
                      random.nextInt(255), random.nextInt(255), 1);
                });
              }),
          SizedBox(
            height: 60.h,
          ),
          // Container(
          //   decoration: const BoxDecoration(color: Colors.grey),
          //   height: 100.h,
          //   width: 300.w,
          //   child: Stack(
          //     children: [
          //       AnimatedPositioned(
          //           height: selected ? 50.h : 100.h,
          //           width: selected ? 100.w : 50.w,
          //           left: selected ? 40.w : 0.w,
          //           top: selected ? 0.h : 10.h,
          //           duration: const Duration(milliseconds: 500),
          //           child: GestureDetector(
          //               onTap: () {
          //                 setState(() {
          //                   selected = !selected;
          //                 });
          //               },
          //               child: Container(
          //                   color: Colors.blue,
          //                   child: const Center(
          //                     child: Text(
          //                       'tap me',
          //                       style: TextStyle(color: Colors.white),
          //                     ),
          //                   ))))
          //     ],
          //   ),
          // ),
          AnimatedTextKit(animatedTexts: [
            ColorizeAnimatedText('Animated Builder',
                textStyle: colorizeTextStyle, colors: colorizeColors)
          ]),
          Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                  animation: builderControler,
                  child: Container(
                    height: 20.h,
                    width: 120.w,
                    decoration: BoxDecoration(
                        color: Colors.brown,
                        borderRadius: BorderRadius.circular(10.r)),
                  ),
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: builderControler.value * math.pi * 2,
                      child: child,
                    );
                  }),
              AnimatedBuilder(
                  animation: builderControler,
                  child: Container(
                    height: 20.h,
                    width: 120.w,
                    decoration: BoxDecoration(
                        color: Colors.brown,
                        borderRadius: BorderRadius.circular(10.r)),
                  ),
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: (builderControler.value * math.pi * 2) - 90,
                      child: child,
                    );
                  }),
              Container(
                height: 20.h,
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
              ),
            ],
          ),

          SizedBox(
            height: 20.h,
          ),
          Row(
            children: [
              // AnimatedBuilder(
              //     animation: rotationWithTween,
              //     child: Container(
              //       height: 100.h,
              //       width: 120.w,
              //       decoration: BoxDecoration(
              //           color: Colors.brown,
              //           borderRadius: BorderRadius.circular(10.r)),
              //     ),
              //     builder: (context, child) {
              //       return RotationTransition(
              //         turns: rotationWithTween,
              //         child: child,
              //       );
              //     }),
              // AnimatedSwitcher(
              //   duration: Duration(seconds: 2),
              //   transitionBuilder: (child,animation){

              //   },),
              SizedBox(
                width: 50.w,
              ),
              // GestureDetector(
              //   onTap: () {
              //     setState(() {
              //       selected = !selected;
              //     });
              //   },
              //   child: AnimatedCrossFade(
              //       firstChild: FlutterLogo(
              //           style: FlutterLogoStyle.horizontal, size: 100.sp),
              //       secondChild: FlutterLogo(
              //           style: FlutterLogoStyle.stacked, size: 100.sp),
              //       crossFadeState: selected
              //           ? CrossFadeState.showSecond
              //           : CrossFadeState.showFirst,
              //       duration: Duration(seconds: 2)),
              // )
            ],
          ),
          SizedBox(
            height: 40.h,
          ),
          AnimatedTextKit(
              repeatForever: true,
              animatedTexts: [WavyAnimatedText('Tween Animation Builder')]),
          TweenAnimationBuilder(
              tween: Tween<double>(begin: 0.01, end: _sliderValue),
              duration: const Duration(milliseconds: 2000),
              child: Slider(
                  value: _sliderValue,
                  min: 0.01,
                  onChanged: (value) {
                    setState(() {
                      _sliderValue = value;
                    });
                  }),
              builder: (context, value, child) {
                return ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: 40 * value, sigmaY: 40 * value),
                    child: child,
                  ),
                );
              }),
          SizedBox(
            height: 30.h,
          ),
          AnimatedTextKit(repeatForever: true, animatedTexts: [
            FlickerAnimatedText('Align And Rotation Transition')
          ]),
          AlignTransition(
              alignment: _alignAnimation,
              child: RotationTransition(
                turns: _rotationAnimation,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: Colors.red,
                  ),
                  height: 50.h,
                  width: 50.w,
                ),
              )),
          SizedBox(
            height: 20.h,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(_createRoute());
              },
              child: const Text('Next'))
        ],
      ),
    );
  }

  _createRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondAnimation) {
          return const AnimationWithTween();
        },
        transitionDuration: const Duration(seconds: 1),
        reverseTransitionDuration: const Duration(seconds: 1),
        transitionsBuilder: (context, animation, secondAnimation, child) {
          const begin = Offset(1, 0);
          const end = Offset.zero;
          const curve = Curves.easeInToLinear;

          final tween = Tween(begin: begin, end: end);
          final curvedAnimation =
              CurvedAnimation(parent: animation, curve: curve);
          // final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        });
  }
}
