import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TypingAnimation extends StatelessWidget {
  const TypingAnimation({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Lottie.asset(
        'assets/lotiesAnimation/typingAnimation.json',
        height: 30,
        width: 80,
      ),
    );
  }
}
