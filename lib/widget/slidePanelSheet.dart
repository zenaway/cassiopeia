import 'package:cassiopeia/page/view.dart';
import 'package:flutter/material.dart';

const minimizedHeightSize = 64;
const Duration slideAnimationDuration = Duration(milliseconds: 100);

class SlidePanelSheet extends StatefulWidget {
  final Widget child;

  SlidePanelSheet({@required this.child});

  static SlidePanelSheetState of(BuildContext context) {
    assert(context != null);
    final SlidePanelSheetState result =
        context.findAncestorStateOfType<SlidePanelSheetState>();
    if (result != null) return result;
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
          'Scaffold.of() called with a context that does not contain a Scaffold.'),
      ErrorDescription(
          'No Scaffold ancestor could be found starting from the context that was passed to Scaffold.of(). '
          'This usually happens when the context provided is from the same StatefulWidget as that '
          'whose build function actually creates the Scaffold widget being sought.'),
      ErrorHint(
          'There are several ways to avoid this problem. The simplest is to use a Builder to get a '
          'context that is "under" the Scaffold. For an example of this, please see the '
          'documentation for Scaffold.of():\n'
          '  https://api.flutter.dev/flutter/material/Scaffold/of.html'),
      ErrorHint(
          'A more efficient solution is to split your build function into several widgets. This '
          'introduces a new context from which you can obtain the Scaffold. In this solution, '
          'you would have an outer widget that creates the Scaffold populated by instances of '
          'your new inner widgets, and then in these inner widgets you would use Scaffold.of().\n'
          'A less elegant but more expedient solution is assign a GlobalKey to the Scaffold, '
          'then use the key.currentState property to obtain the ScaffoldState rather than '
          'using the Scaffold.of() function.'),
      context.describeElement('The context used was')
    ]);
  }

  @override
  SlidePanelSheetState createState() => SlidePanelSheetState();
}

class SlidePanelSheetState extends State<SlidePanelSheet>
    with TickerProviderStateMixin {
  AnimationController slideAnimationController;
  Animation _slideAnimation;

  final PageController _pageController = PageController();

  @override
  void initState() {
    slideAnimationController =
        AnimationController(duration: slideAnimationDuration, vsync: this);
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
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (slideAnimationController.isCompleted) {
          slideAnimationController.reverse();
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
            child: Stack(
              children: [
                View(
                  viewHeight: MediaQuery.of(context).size.height,
                  controller: _pageController,
                ),
                Positioned.fill(
                  child: PageView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: 2,
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return Container();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
