import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

const Duration slideAnimationDuration = Duration(milliseconds: 200);
const double bufferedHorizontalHeight = 15.0;
const double bufferedVerticalHeight = 300.0;

class SlidePanelSheet extends StatefulWidget {
  final Widget child;

  SlidePanelSheet({@required this.child});

  static SlidePanelSheetState of(BuildContext context) {
    assert(context != null);
    final SlidePanelSheetState result =
        context.findAncestorStateOfType<SlidePanelSheetState>();
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
  SlidePanelSheetState createState() => SlidePanelSheetState();
}

class SlidePanelSheetState extends State<SlidePanelSheet>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController(
    initialPage: 0,
    viewportFraction: 1.0,
  );

  AnimationController slideAnimationController;
  AnimationController _scrollAnimationController;
  Animation _slideAnimation;

  VideoPlayerController _videoController;
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

    super.initState();
  }

  @override
  void dispose() {
    slideAnimationController.dispose();
    _pageController.dispose();

    super.dispose();
  }

  void openPanel(String url) {
    print(url ?? "???");
    if (_scrollAnimationController.value !=
        MediaQuery.of(context).size.height) {
      _scrollAnimationController.fling(velocity: 1.0);
    }
    // _scrollAnimationController.value = MediaQuery.of(context).size.height;
    slideAnimationController.forward();
  }

  // _videoController = VideoPlayerController.network(
  //       'https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4')
  //     ..initialize().then((value) => setState(() {}));

  @override
  Widget build(BuildContext context) {
    final Size windowSize = MediaQuery.of(context).size;
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
              resizeAniController: _scrollAnimationController,
              vidioPlayController: _videoController,
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
  final AnimationController resizeAniController;
  final VideoPlayerController vidioPlayController;

  SlidePanel({
    Key key,
    @required this.maxHeight,
    @required this.minHeight,
    @required this.maxWidth,
    @required this.minWidth,
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

  AnimationController _scrollAnimationController;

  @override
  void initState() {
    super.initState();

    _panelHeight = widget.maxHeight;
    _aspectViewHeight = widget.maxWidth / 3 * 2;

    _viewContainerWidth = widget.maxWidth;
    _viewContainerHeight = _aspectViewHeight;

    _scrollAnimationController = widget.resizeAniController;
    _scrollAnimationController.addListener(
      () => setState(
        () {
          _panelHeight = _scrollAnimationController.value;
          if (_scrollAnimationController.value == widget.maxHeight) {
            _extended = true;
          }
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
            _verticalAnimationRatio =
                (_scrollAnimationController.value - _aspectViewHeight) /
                    bufferedVerticalHeight;
          } else if (_aspectViewHeight + bufferedVerticalHeight <
                  _scrollAnimationController.value &&
              _verticalAnimationRatio != 0.0) {
            _verticalAnimationRatio = 1.0;
          } else if (_verticalAnimationRatio != 0.0) {
            _verticalAnimationRatio = 0.0;
          }
        },
      ),
    );
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
    if (_extended && _panelHeight != widget.maxHeight) {
      _scrollAnimationController.fling(velocity: -0.5);
      _extended = false;
    } else if (!_extended && _panelHeight != widget.minHeight) {
      _scrollAnimationController.fling(velocity: 0.5);
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
          onTap: () {},
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
                      // child: VideoPlayer(
                      //   _videoController,
                      // ),
                    ),
                  ),
                  Container(
                    width: widget.maxWidth - _viewContainerWidth,
                    height: widget.minHeight,
                    color: Colors.orange
                        .withOpacity(1 - _horizontalAnimationRatio),
                  ),
                ],
              ),
              Opacity(
                opacity: _verticalAnimationRatio,
                child: Container(
                  height: _panelHeight - _viewContainerHeight,
                  width: widget.maxWidth * 0.6 +
                      widget.maxWidth * 0.4 * _verticalAnimationRatio,
                  color: Colors.orange,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
