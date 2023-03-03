import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonAnimation extends AnimatedWidget {
  const ButtonAnimation({super.key, required controller, required this.onTap})
      : super(listenable: controller);
  final VoidCallback onTap;

  Animation<double> get width => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            side: BorderSide(color: Colors.cyan, width: width.value * 10)),
        onPressed: onTap,
        child: const Text('switch container'));
  }
}
