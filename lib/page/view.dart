import 'package:flutter/material.dart';

const minimizedHeightSize = 64;
const Duration slideAnimationDuration = Duration(milliseconds: 100);

class View extends StatefulWidget {
  final double viewHeight;
  final PageController controller;

  View({
    @required this.viewHeight,
    @required this.controller,
  });

  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> {
  // AnimationController _sizeAnimationController;
  // Animation<double> _sizeAnimation;

  double height = 0;

  @override
  void initState() {
    height = widget.viewHeight;
    // _sizeAnimationController =
    //     AnimationController(duration: slideAnimationDuration, vsync: this)
    //       ..forward();
    // _sizeAnimation = CurvedAnimation(
    //   parent: _sizeAnimationController,
    //   curve: Curves.linear,
    // );

    widget.controller.addListener(() {
      print(widget.controller.page * widget.viewHeight >= minimizedHeightSize);
      setState(() {
        if (widget.controller.page * widget.viewHeight >= minimizedHeightSize) {
          height = widget.controller.page * widget.viewHeight;
        } else {
          height = 64;
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      print(constraints);
      return Container(
        height: height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: GestureDetector(
          onVerticalDragUpdate: (DragUpdateDetails detail) {},
          child: SafeArea(
            child: Text("???"),
          ),
        ),
      );
    });
  }
}
