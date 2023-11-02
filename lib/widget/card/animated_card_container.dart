import 'package:flutter/material.dart';

class AnimatedCardContainer extends StatefulWidget {

  final Widget child;
  final Function() onTap;

  const AnimatedCardContainer({Key? key, required this.child, required this.onTap}) : super(key: key);

  @override
  State<AnimatedCardContainer> createState() => _AnimatedCardContainerState();
}

class _AnimatedCardContainerState extends State<AnimatedCardContainer> {

  double scale = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap.call();
        setState(() {
          scale = 1;
        });
      },
      onTapDown: (details) {
        setState(() {
          scale = 0.97;
        });
      },
      onTapCancel: () {
        setState(() {
          scale = 1;
        });
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 50),
          scale: scale,
          child: widget.child),
    );
  }
}
