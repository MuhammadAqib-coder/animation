import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeroAnimation extends StatelessWidget {
  const HeroAnimation({super.key, required this.image});
  final String image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedTextKit(totalRepeatCount: 1, animatedTexts: [
          TypewriterAnimatedText(
            'Hero Animation',
            speed: const Duration(milliseconds: 200),
          )
        ]),
      ),
      body: ListView(
        children: [
          Hero(
            tag: image,
            child: SizedBox(
              height: 300.h,
              child: Image.asset(image),
            ),
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
  }
}
