import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

const Duration slideAnimationDuration = Duration(milliseconds: 200);
const double bufferedHorizontalHeight = 15.0;
const double bufferedVerticalHeight = 300.0;

class SlidePanelSheet extends StatefulWidget {
  final Widget child;

  SlidePanelSheet({@required this.child});

  static _SlidePanelSheetState of(BuildContext context) {
    assert(context != null);
    final _SlidePanelSheetState result =
        context.findAncestorStateOfType<_SlidePanelSheetState>();
    if (result != null) return result;
    throw FlutterError.fromParts(
      <DiagnosticsNode>[
        ErrorSummary(
          'SlidePanelSheet.of() called with a context that does not contain a SlidePanelSheet.',
        ),
        context.describeElement(
          'The context used was',
        )
      ],
    );
  }

  @override
  _SlidePanelSheetState createState() => _SlidePanelSheetState();
}

class _SlidePanelSheetState extends State<SlidePanelSheet>
    with TickerProviderStateMixin {
  AnimationController slideAnimationController;
  AnimationController _scrollAnimationController;
  Animation _slideAnimation;

  VideoPlayerController _videoController;

  ChewieController _chewieController;

  @override
  void initState() {
    slideAnimationController = AnimationController(
      duration: slideAnimationDuration,
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: slideAnimationController,
        curve: Curves.linear,
      ),
    );

    _videoController = VideoPlayerController.network(
      'https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4',
    )..initialize().then((value) {
        _chewieController = ChewieController(
          videoPlayerController: _videoController,
          allowFullScreen: true,
          autoInitialize: true,
        );
      }).then((value) => setState(() {}));

    super.initState();
  }

  @override
  void dispose() {
    slideAnimationController.dispose();
    _scrollAnimationController.dispose();
    _videoController.dispose();

    super.dispose();
  }

  void openPanel(String url) {
    if (_scrollAnimationController.value !=
        MediaQuery.of(context).size.height) {
      _scrollAnimationController.fling(velocity: 1.0);
    }
    slideAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final Size windowSize = MediaQuery.of(context).size;
    final EdgeInsets windowPadding = MediaQuery.of(context).padding;
    if (_scrollAnimationController == null) {
      _scrollAnimationController = AnimationController(
        vsync: this,
        upperBound: windowSize.height,
        lowerBound: 64,
        value: windowSize.height,
        duration: Duration.zero,
      );
    }
    return WillPopScope(
      onWillPop: () async {
        if (slideAnimationController.isCompleted) {
          await slideAnimationController.reverse();
          return false;
        } else {
          return true;
        }
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          widget.child,
          SlideTransition(
            position: _slideAnimation,
            child: SlidePanel(
              maxHeight: windowSize.height,
              minHeight: 64,
              maxWidth: windowSize.width,
              minWidth: 96,
              topPadding: windowPadding.top,
              resizeAniController: _scrollAnimationController,
              vidioPlayController: _chewieController,
            ),
          ),
        ],
      ),
    );
  }
}

class SlidePanel extends StatefulWidget {
  final double maxHeight;
  final double minHeight;
  final double maxWidth;
  final double minWidth;
  final double topPadding;
  final AnimationController resizeAniController;
  final ChewieController vidioPlayController;

  SlidePanel({
    Key key,
    @required this.maxHeight,
    @required this.minHeight,
    @required this.maxWidth,
    @required this.minWidth,
    @required this.topPadding,
    @required this.resizeAniController,
    @required this.vidioPlayController,
  }) : super(key: key);

  @override
  _SlidePanelState createState() => _SlidePanelState();
}

class _SlidePanelState extends State<SlidePanel> {
  double _panelHeight = 0;
  double _viewContainerHeight = 0;
  double _viewContainerWidth = 0;
  bool _extended = true;

  double _aspectViewHeight = 0;

  double _horizontalAnimationRatio = 1.0;
  double _verticalAnimationRatio = 1.0;
  double _topPaddingRatio = 1.0;

  @override
  void initState() {
    super.initState();

    _panelHeight = widget.maxHeight;
    _aspectViewHeight = widget.maxWidth / 3 * 2;

    _viewContainerWidth = widget.maxWidth;
    _viewContainerHeight = _aspectViewHeight;

    widget.resizeAniController.addListener(
      () => setState(
        () {
          // if(widget.resizeAniController.value)
          //
          // 구간
          // 최대높이 - 패딩톱 ~ 비율높이 + 버퍼높이
          // 비율높이 + 버퍼높이 ~ 비율높이
          // 비율높이 ~ 최소높이 + 버퍼
          // 최소높이 + 버퍼 ~ 최소높이

          if (widget.resizeAniController.value <= widget.maxHeight &&
              widget.maxHeight - widget.topPadding <=
                  widget.resizeAniController.value) {
            _topPaddingRatio = 1.0 -
                (widget.maxHeight - widget.resizeAniController.value) /
                    widget.topPadding;
          } else if (widget.resizeAniController.value == widget.maxHeight) {
            _topPaddingRatio = 1.0;
          } else {
            _topPaddingRatio = 0.0;
          }
          if (widget.resizeAniController.value == widget.maxHeight) {
            _extended = true;
          }
          if (_panelHeight < _aspectViewHeight) {
            _viewContainerHeight = _panelHeight;
          } else if (_panelHeight >= _aspectViewHeight) {
            _viewContainerHeight = _aspectViewHeight;
          }
          if (widget.minHeight + bufferedHorizontalHeight >=
              widget.resizeAniController.value) {
            _horizontalAnimationRatio =
                ((widget.minHeight - widget.resizeAniController.value) /
                        bufferedHorizontalHeight)
                    .abs();
            _viewContainerWidth = widget.minWidth +
                (widget.maxWidth - widget.minWidth) * _horizontalAnimationRatio;
          } else if (widget.minHeight + bufferedHorizontalHeight <
              widget.resizeAniController.value) {
            _viewContainerWidth = widget.maxWidth;
            _horizontalAnimationRatio = 1.0;
          }
          if (_aspectViewHeight + bufferedVerticalHeight >=
                  widget.resizeAniController.value &&
              _aspectViewHeight < widget.resizeAniController.value) {
            _verticalAnimationRatio =
                (widget.resizeAniController.value - _aspectViewHeight) /
                    bufferedVerticalHeight;
          } else if (_aspectViewHeight + bufferedVerticalHeight <
                  widget.resizeAniController.value &&
              _verticalAnimationRatio != 0.0) {
            _verticalAnimationRatio = 1.0;
          } else if (_verticalAnimationRatio != 0.0) {
            _verticalAnimationRatio = 0.0;
          }
          //
          //
          //
          // if (widget.resizeAniController.value == widget.maxHeight) {
          //   // 높이 == 최대높이
          //   _topPaddingRatio = 1.0;
          //   _extended = true;
          // } else if (widget.resizeAniController.value < widget.maxHeight &&
          //     widget.resizeAniController.value >=
          //         widget.maxHeight - widget.topPadding) {
          //   //높이 = 최대높이 ~ toppadding height
          //   _topPaddingRatio =
          //       ((widget.maxHeight - widget.resizeAniController.value) /
          //               widget.topPadding) *
          //           -1;
          // } else if (_topPaddingRatio != 0.0) {
          //   //판정 범위 밖
          //   _topPaddingRatio = 0.0;
          // }
          // if (widget.resizeAniController.value >
          //     _aspectViewHeight + bufferedVerticalHeight) {
          //   // 높이 > 비율높이 + 버퍼높이
          //   _
          // }

          _panelHeight = widget.resizeAniController.value;
        },
      ),
    );
  }

  updateDrag(DragUpdateDetails details) {
    double _nextHeight = widget.resizeAniController.value - details.delta.dy;
    widget.resizeAniController.animateTo(
      _nextHeight,
      duration: Duration.zero,
    );
    if (_panelHeight == widget.minHeight && details.delta.dy > 1.0) {
      SlidePanelSheet.of(context).slideAnimationController.reverse();
      widget.vidioPlayController.pause();
    }
  }

  updateDragEnd(DragEndDetails details) {
    if (_extended && _panelHeight != widget.maxHeight) {
      widget.resizeAniController.fling(velocity: -0.5);
      _extended = false;
    } else if (!_extended && _panelHeight != widget.minHeight) {
      widget.resizeAniController.fling(velocity: 0.5);
      _extended = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _panelHeight,
      color: Colors.white,
      child: GestureDetector(
        onTap: () {
          if (widget.vidioPlayController.isPlaying) {
            widget.vidioPlayController.pause();
          } else {
            widget.vidioPlayController.play();
          }
        },
        onVerticalDragUpdate: (details) {
          updateDrag(details);
        },
        onVerticalDragEnd: (details) {
          updateDragEnd(details);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: widget.topPadding * _topPaddingRatio,
            ),
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
                    child: widget.vidioPlayController != null
                        ? Chewie(
                            controller: widget.vidioPlayController,
                          )
                        : null,
                  ),
                ),
                Container(
                  width: widget.maxWidth - _viewContainerWidth,
                  height: widget.minHeight,
                  color:
                      Colors.orange.withOpacity(1 - _horizontalAnimationRatio),
                ),
              ],
            ),
            Opacity(
              opacity: _verticalAnimationRatio,
              child: Container(
                height: _panelHeight -
                    _viewContainerHeight -
                    widget.topPadding * _topPaddingRatio,
                width: widget.maxWidth * 0.6 +
                    widget.maxWidth * 0.4 * _verticalAnimationRatio,
                color: Colors.orange,
              ),
            )
          ],
        ),
      ),
    );
  }
}
