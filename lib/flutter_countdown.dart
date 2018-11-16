library countdown;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class _Countdown extends AnimatedWidget {
  final Animation<int> animation;
  final String Function(int number) renderSemanticLabel;
  final TextStyle textStyle;

  _Countdown({Key key, this.animation, this.renderSemanticLabel, this.textStyle})
      : super(key: key, listenable: animation);

  @override
  build(BuildContext context) {
    int count = animation.value;
    return Text(renderSemanticLabel(count), style: textStyle, textDirection: TextDirection.ltr,);
  }
}

class CountDown extends StatefulWidget {
  final int beginCount;
  final int endCount;
  final String semanticLabel;
  final String defaultSemanticLabel;
  final String Function(int number) renderSemanticLabel;
  final void Function(AnimationController refs) refs;
  final Future<bool> Function(AnimationController ctr) onPress;
  final AnimationStatusListener statusListener;

  CountDown({this.semanticLabel, this.defaultSemanticLabel, this.beginCount,
      this.endCount, this.statusListener, this.refs, this.onPress, this.renderSemanticLabel});

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
    return CupertinoButton(
      onPressed: () => _beginCountIfNeed(_controller),
      padding: const EdgeInsets.all(0),
      child: _Countdown(
        renderSemanticLabel: (count) => widget.renderSemanticLabel(count),
        animation: new StepTween(
          begin: widget.beginCount,
          end: widget.endCount,
        ).animate(_controller),
      ),
    );
  }
}
