library countdown;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class _Countdown extends AnimatedWidget {
  final Animation<int> animation;
  final String Function(int number) renderLabel;
  final TextStyle textStyle;

  _Countdown(
      {Key key, this.animation, this.renderLabel, this.textStyle})
      : super(key: key, listenable: animation);

  @override
  build(BuildContext context) {
    int count = animation.value;
    return Text(
      renderLabel(count),
      style: textStyle,
      textDirection: TextDirection.ltr,
    );
  }
}

class CountDown extends StatefulWidget {
  final int beginCount;
  final int endCount;
  // renderSemanticLabel is deprecated and shouldn't be used.
  // you can use renderLabel
  final String Function(int number) renderSemanticLabel;
  final String Function(int number) renderLabel;
  final void Function(AnimationController refs) refs;
  final Future<bool> Function(AnimationController ctr) onPress;
  final AnimationStatusListener statusListener;
  final TextStyle textStyle;

  CountDown(
      {this.beginCount,
      this.endCount,
      this.statusListener,
      this.refs,
      this.onPress,
      this.renderLabel,
      this.textStyle,
      this.renderSemanticLabel});

  @override
  State<StatefulWidget> createState() => CounDownState();
}

class CounDownState extends State<CountDown> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: new Duration(seconds: widget.beginCount),
    );

    _controller.addStatusListener((state) {
      if (state == AnimationStatus.completed) {
        _controller.reset();
      }
      if (widget.statusListener != null) {
        widget.statusListener(state);
      }
    });

    if (widget.statusListener != null) {
      widget.refs(_controller);
    }
  }

  _beginCountIfNeed(AnimationController ctr) async {
    bool isNeedCount = await widget.onPress(ctr);
    if (isNeedCount) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _beginCountIfNeed(_controller),
      child: _Countdown(
        renderLabel: (count) {
          if (widget.renderLabel != null) {
            return widget.renderLabel(count);
          }
          return widget.renderSemanticLabel(count);
        },
        textStyle: widget.textStyle,
        animation: new StepTween(
          begin: widget.beginCount,
          end: widget.endCount,
        ).animate(_controller),
      ),
    );
  }
}
