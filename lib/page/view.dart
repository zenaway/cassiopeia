import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

const Duration slideAnimationDuration = Duration(milliseconds: 100);
const double bufferedHorizontalHeight = 10.0;
const double bufferedVerticalHeight = 100.0;

class View extends StatefulWidget {
  final double maxHeight;
  final double minHeight;
  final double maxWidth;
  final double minWidth;

  View({
    @required this.maxHeight,
    @required this.minHeight,
    @required this.maxWidth,
    @required this.minWidth,
  });

  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> with TickerProviderStateMixin {
  double _panelHeight = 0;
  double _viewContainerHeight = 0;
  double _viewContainerWidth = 0;
  bool _extended = true;

  double _aspectViewHeight = 0;

  double _horizontalAnimationRatio = 1.0;
  double _verticalAnimationRatio = 0.0;

  AnimationController _scrollAnimationController;
  // AnimationController _verticalContentsAnimationController;
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
    _aspectViewHeight = widget.maxWidth / 3 * 2;

    _viewContainerWidth = widget.maxWidth;
    _viewContainerHeight = _aspectViewHeight;

    _scrollAnimationController = AnimationController(
      vsync: this,
      upperBound: widget.maxHeight,
      lowerBound: widget.minHeight,
      value: widget.maxHeight,
      duration: Duration.zero,
    )..addListener(() {
        setState(() {
          _panelHeight = _scrollAnimationController.value;
          if (_panelHeight < _aspectViewHeight) {
            _viewContainerHeight = _panelHeight;
          } else if (_panelHeight >= _aspectViewHeight) {
            _viewContainerHeight = _aspectViewHeight;
          }
          if (widget.minHeight + bufferedHorizontalHeight >=
              _scrollAnimationController.value) {
            _horizontalAnimationRatio =
                ((widget.minHeight - _scrollAnimationController.value) /
                        bufferedHorizontalHeight)
                    .abs();
            _viewContainerWidth = widget.minWidth +
                (widget.maxWidth - widget.minWidth) * _horizontalAnimationRatio;
          } else if (widget.minHeight + bufferedHorizontalHeight <
              _scrollAnimationController.value) {
            _viewContainerWidth = widget.maxWidth;
            _horizontalAnimationRatio = 1.0;
          }
          if (_aspectViewHeight + bufferedVerticalHeight >=
                  _scrollAnimationController.value &&
              _aspectViewHeight < _scrollAnimationController.value) {
            print("${_scrollAnimationController.value} if");
          } else if (_aspectViewHeight + bufferedVerticalHeight <
              _scrollAnimationController.value) {
            print("${_scrollAnimationController.value} else if");
          } else {
            print("${_scrollAnimationController.value} else");
          }
        });
      });

    // _verticalContentsAnimationController = AnimationController(
    //   vsync: this,
    //   duration: Duration.zero,
    // );
  }

  @override
  void dispose() {
    super.dispose();
  }

  updateDrag(DragUpdateDetails details) {
    double _nextHeight = _scrollAnimationController.value - details.delta.dy;
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _panelHeight,
      color: Colors.white,
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    height: _viewContainerHeight,
                    width: _viewContainerWidth,
                    color: Colors.black,
                    child: AspectRatio(
                      aspectRatio: 3 / 2,
                      child: Container(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  Container(
                    width: widget.maxWidth - _viewContainerWidth,
                    height: widget.minHeight,
                    color: Colors.orange
                        .withOpacity(1 - _horizontalAnimationRatio),
                  ),
                  // SlideTransition(position: , child: FadeTransition(child: ,),),
                ],
              ),
              Container(
                height: _panelHeight - _viewContainerHeight,
                color: Colors.orange,
              )
              // FadeTransition(opacity:  ,child: SizedBox(height: ,),),
            ],
          ),
        ),
      ),
    );
  }
}
