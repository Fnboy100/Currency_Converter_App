// ignore_for_file:prefer_const_constructors
// ignore_for_file:prefer_const_constructors_in_immutables
import 'package:flutter/material.dart';

class MovingText
    extends StatefulWidget {
  MovingText(
      {super.key});
  @override
  State<StatefulWidget>
      createState() {
    return _MovingTextState();
  }
}

class _MovingTextState
    extends State
    with
        SingleTickerProviderStateMixin {
  late AnimationController
      _controller;
  late Animation<double>
      _animation;

  @override
  void
      initState() {
    super.initState();
    _controller =
        AnimationController(
      duration: const Duration(seconds: 8), 
      vsync: this,
    )..repeat(); 

    _animation =
        Tween<double>(begin: -200, end: 200).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
  }

  @override
  Widget
      build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_animation.value, 0),
            child: child,
          );
        },
        child: Text(
           "Real-time exchange rate of Naira to Dollar",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  void
      dispose() {
    _controller.dispose();
    super.dispose();
  }
}
