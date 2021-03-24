import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

const double minimizedHeightSize = 64;
const Duration slideAnimationDuration = Duration(milliseconds: 100);

class View extends StatefulWidget {
  final double maxHeight;
  final double minHeight;
  View({
    @required this.maxHeight,
    @required this.minHeight,
  });

  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> with TickerProviderStateMixin {
  double _panelHeight = 0;
  double _verticalContentsOpacity = 1.0;
  double _horizontalContentsOpacity = 0.0;
  bool _extended = true;
  AnimationController _scrollAnimationController;
  AnimationController _verticalContentsAnimationController;
  // AnimationController _verticalContentsAnimationController;

  YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'WPPPFqsECz0',
    params: YoutubePlayerParams(
      // startAt: Duration(milliseconds: 30),
      autoPlay: true,
      showControls: true,
      showFullscreenButton: true,
    ),
  );

  @override
  void initState() {
    super.initState();

    _panelHeight = widget.maxHeight;
    _scrollAnimationController = AnimationController(
      vsync: this,
      upperBound: widget.maxHeight,
      lowerBound: widget.minHeight,
      value: widget.maxHeight,
      duration: Duration.zero,
    )..addListener(() {
        setState(() {
          _panelHeight = _scrollAnimationController.value;
        });
      });

    _verticalContentsAnimationController = AnimationController(
      vsync: this,
      duration: Duration.zero,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  updateHeight() {
    // setState(() {
    //   if ((1 - widget.controller.page) * widget.maxHeight >=
    //       minimizedHeightSize) {
    //     height = (1 - widget.controller.page) * widget.maxHeight;
    //   } else {
    //     height = 64;
    //   }
    //   verticalContentsFlex = (65 - widget.controller.page * 65).round();
    // });
  }

  updateDrag(DragUpdateDetails details) {
    double _nextHeight = _scrollAnimationController.value - details.delta.dy;
    if (details.delta.dy > 0) {
    } else if (details.delta.dy < 0) {}

    _scrollAnimationController.animateTo(
      _nextHeight,
      duration: Duration.zero,
    );
  }

  updateDragEnd() {
    if (_extended) {
      _scrollAnimationController.fling(velocity: -1.0);
      _extended = false;
    } else {
      _scrollAnimationController.fling(velocity: 1.0);
      _extended = true;
    }
    // if (_panelHeight != widget.maxHeight && _panelHeight != widget.minHeight) {
    //   double _nextHeight;
    //   bool _nextExtended;
    //   if (!_extended) {
    //     _nextHeight = widget.maxHeight;
    //     _nextExtended = true;
    //   } else if (_extended) {
    //     _nextHeight = widget.minHeight;
    //     _nextExtended = false;
    //   }
    //   setState(() {
    //     _panelHeight = _nextHeight;
    //     _extended = _nextExtended;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _panelHeight,
      child: SafeArea(
        top: false,
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
            updateDrag(details);
          },
          onVerticalDragEnd: (details) {
            updateDragEnd();
          },
          child: Column(
            children: [
              Expanded(
                flex: 35,
                child: Row(
                  children: [
                    Expanded(
                      flex: 35,
                      child: Container(
                        color: Colors.black,
                      ),
                      // child: YoutubePlayerIFrame(
                      //   controller: _controller,
                      //   aspectRatio: 3 / 2,
                      // ),
                    ),
                    // if (_verticalContentsFlex < 15)
                    // Expanded(
                    //   flex: 65,
                    //   child: Opacity(
                    //     opacity: _horizontalContentsOpacity,
                    //     child: Container(
                    //       color: Colors.white,
                    //       child: Center(
                    //         child: ElevatedButton(
                    //           onPressed: () {
                    //             print("??");
                    //           },
                    //           child: Text("????"),
                    //         ),
                    //       ),
                    //       // color: Colors.white
                    //       //     .withOpacity((10 - verticalContentsFlex) / 10),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              // if (_verticalContentsFlex > 15)
              Expanded(
                flex: 65,
                child: Opacity(
                  opacity: _verticalContentsOpacity,
                  child: Container(
                    color: Colors.white,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          print("??");
                        },
                        child: Text("????"),
                      ),
                    ),
                    // color:
                    //     Colors.white.withOpacity((65 - verticalContentsFlex) / 100),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
