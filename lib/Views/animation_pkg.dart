import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimationPkg extends StatefulWidget {
  const AnimationPkg({super.key});

  @override
  State<AnimationPkg> createState() => _AnimationPkgState();
}

class _AnimationPkgState extends State<AnimationPkg> {
  var pageController = PageController(viewportFraction: 0.8);
  var currentPage = 0.0;
  final double _scaleFactor = 0.8;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController.addListener(() {
      setState(() {
        currentPage = pageController.page!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Animation Pkg'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.sp),
        child: Column(
          children: [
            Expanded(
                child: ListView(
              children: [
                OpenContainer(
                  transitionType: ContainerTransitionType.fadeThrough,
                  closedColor: Colors.cyanAccent,
                  transitionDuration: const Duration(seconds: 1),
                  closedBuilder: (context, action) {
                    return ListTile(
                      tileColor: Colors.cyan,
                      textColor: Colors.white,
                      leading: Image.asset('assets/child1.png'),
                      title: const Text(
                        'scientist',
                      ),
                    );
                  },
                  openBuilder: (context, action) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 2.w, color: Colors.cyan),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50.h,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(Icons.arrow_back_ios)),
                          ),
                          SizedBox(
                            height: 200.h,
                            child: Image.asset('assets/child1.png'),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.sp),
                            child: const Text(
                                maxLines: 20,
                                textDirection: TextDirection.ltr,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.justify,
                                "Study refers to the process of learning and acquiring knowledge through various methods, such as reading, researching, practicing, and analyzing information. It involves a systematic and structured approach to understanding a subject matter, and typically involves the use of educational resources such as textbooks, lectures, and online resources. Studying is often associated with academic pursuits, such as earning a degree or certification, but it can also be a personal or professional endeavor aimed at improving  skills or gaining knowledge in a particular area. Effective study requires discipline, focus, and organization, as well as a willingness to engagewith and apply the material being studied."),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ],
            )),
            SizedBox(
                height: 200.h,
                child: PageView.builder(
                  controller: pageController,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return _buildPageItem(index);
                  },
                ))
          ],
        ),
      ),
    );
  }

  _buildPageItem(index) {
    Matrix4 matrix = Matrix4.identity();
    if (index == currentPage.floor()) {
      var currScale = 1 - (currentPage - index) * (1 - _scaleFactor);
      var currTrans = 190 * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
      // print(matrix);
    } else if (index == currentPage.floor() + 1) {
      var currScale =
          _scaleFactor + (currentPage - index + 1) * (1 - _scaleFactor);
      var currTrans = 190 * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == currentPage.floor() - 1) {
      var currScale = 1 - (currentPage - index) * (1 - _scaleFactor);
      var currTrans = 190 * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else {
      var currScale = 0.8;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, 190 * (1 - _scaleFactor) / 2, 1);
    }

    return Transform(
      transform: matrix,
      child: Container(
        margin: EdgeInsets.all(10.sp),
        height: 180.h,
        decoration: BoxDecoration(
            color: index == 0
                ? Colors.yellow
                : index == 1
                    ? Colors.cyan
                    : Colors.redAccent,
            borderRadius: BorderRadius.circular(10.r),
            image:
                const DecorationImage(image: AssetImage('assets/child1.png'))),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  late final Animation<double> position;
  final Animation<double> controller;
  final int waves;
  final double waveAmplitude;

  WavePainter(
      {required this.controller,
      required this.waves,
      required this.waveAmplitude}) {
    position = Tween(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: Curves.linear))
        .animate(controller);
  }

  int get waveSegment => 2 * waves - 1;

  drawWave(Path path, wave, size) {
    double waveWidth = size.width / waveSegment;
    double waveMinHeight = size.height / waveSegment;

    double x1 = wave * waveWidth + waveWidth / 2;
    double y1 = waveMinHeight + (wave.isOdd ? waveAmplitude : -waveAmplitude);

    double x2 = x1 + waveWidth / 2;
    double y2 = waveMinHeight;

    path.quadraticBezierTo(x1, y1, x2, y2);
    if (wave <= waveSegment) {
      drawWave(path, wave + 1, size);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.lightBlue
      ..style = PaintingStyle.fill;

    Path path = Path()..moveTo(0, size.height / 2);
    drawWave(path, 0, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
