import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageAnimation extends StatefulWidget {
  final int numberOfImages;
  final int duration;
  final AnimationsGame animationsGame;
  final double size;

  const ImageAnimation({
    required this.animationsGame ,
    required this.numberOfImages,
    required this.duration,
    required this.size,
    super.key,
  });

  @override
  ImageAnimationState createState() => ImageAnimationState();
}

class ImageAnimationState extends State<ImageAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  AudioCache audioCache = AudioCache();

  Future<void> playSound() async {
    await audioCache.loadAsFile(widget.animationsGame.soundPath);
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration),
    );

    _animation = IntTween(
      begin: 1,
      end: widget.numberOfImages,
    ).animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        playSound();
        return Image.asset(
          '${widget.animationsGame.spritePath}${_animation.value}.png',
          width: widget.size.w,
        );
      },
    );
  }
}

enum AnimationsGame {
  explosion,
  battle;

  String get spritePath {
    switch (this) {
      case AnimationsGame.explosion:
        return 'assets/images/explosion/explosion_0';
      case AnimationsGame.battle:
        return 'assets/images/explosion/explosion_0';
    }
  }

  String get soundPath {
    switch (this) {
      case AnimationsGame.explosion:
        return 'audio/explosion.mp3';
      case AnimationsGame.battle:
        return 'audio/battle.mp3';
    }
  }
}
