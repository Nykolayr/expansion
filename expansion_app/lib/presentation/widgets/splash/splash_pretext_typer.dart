import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:expansion/core/constants/splash_intro_timing.dart';
import 'package:expansion/core/themes/expansion_text_styles.dart';

/// Печать вступительного текста посимвольно; при переполнении окна — прокрутка вниз.
class SplashPretextTyper extends StatefulWidget {
  const SplashPretextTyper({
    required this.text,
    this.onComplete,
    this.onProgress,
    this.charactersPerStep = 1,
    this.stepDuration =
        const Duration(milliseconds: SplashIntroTiming.msPerChar),
    super.key,
  });

  final String text;
  final VoidCallback? onComplete;
  final void Function(int visibleLength, int totalLength)? onProgress;
  final int charactersPerStep;
  final Duration stepDuration;

  @override
  State<SplashPretextTyper> createState() => _SplashPretextTyperState();
}

class _SplashPretextTyperState extends State<SplashPretextTyper> {
  Timer? _timer;
  final ScrollController _scrollController = ScrollController();
  int _visibleLength = 0;
  bool _completedNotified = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _startTyping();
    });
  }

  @override
  void didUpdateWidget(SplashPretextTyper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _completedNotified = false;
      _restartTyping();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _restartTyping() {
    _timer?.cancel();
    _visibleLength = 0;
    _startTyping();
  }

  void _notifyComplete() {
    if (_completedNotified) return;
    _completedNotified = true;
    widget.onComplete?.call();
  }

  void _scrollToLatestLine() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      final position = _scrollController.position;
      _scrollController.jumpTo(position.maxScrollExtent);
    });
  }

  void _appendCharacters() {
    setState(() {
      _visibleLength = (_visibleLength + widget.charactersPerStep)
          .clamp(0, widget.text.length);
    });
    widget.onProgress?.call(_visibleLength, widget.text.length);
    _scrollToLatestLine();
  }

  void _startTyping() {
    if (widget.text.isEmpty) {
      _notifyComplete();
      return;
    }
    _timer = Timer.periodic(widget.stepDuration, (_) {
      if (!mounted) return;
      if (_visibleLength >= widget.text.length) {
        _timer?.cancel();
        _notifyComplete();
        return;
      }
      _appendCharacters();
      if (_visibleLength >= widget.text.length) {
        _timer?.cancel();
        _notifyComplete();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final visible = widget.text.substring(0, _visibleLength);
    return SingleChildScrollView(
      controller: _scrollController,
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          visible,
          style: ExpansionTextStyles.bodyOnDark(context, 18),
        ),
      ),
    );
  }
}
