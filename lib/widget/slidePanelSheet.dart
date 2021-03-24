import 'package:cassiopeia/page/view.dart';
import 'package:flutter/material.dart';

const Duration slideAnimationDuration = Duration(milliseconds: 100);

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
  Animation _slideAnimation;

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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (slideAnimationController.isCompleted) {
          await slideAnimationController.reverse();
          if (_pageController.page == 1) {
            _pageController.jumpTo(0);
          }
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
            child: View(
              maxHeight: MediaQuery.of(context).size.height,
              minHeight: 64,
            ),
          ),
        ],
      ),
      // child: Stack(
      //   alignment: Alignment.bottomCenter,
      //   children: [
      //     widget.child,
      //     SlideTransition(
      //       position: _slideAnimation,
      //       child: Stack(
      //         children: [
      //           View(
      //             viewHeight: MediaQuery.of(context).size.height,
      //             controller: _pageController,
      //           ),
      //           Positioned.fill(
      //             child: PageView.builder(
      //               itemCount: 2,
      //               controller: _pageController,
      //               scrollDirection: Axis.vertical,
      //               physics: BouncingScrollPhysics(),
      //               reverse: true,
      //               itemBuilder: (context, index) {
      //                 return Container();
      //               },
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
