import 'package:cassiopeia/widget/bottomNav.dart';
import 'package:cassiopeia/widget/header.dart';
import 'package:cassiopeia/widget/slidePanelSheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final int _scrollSensitivity = 2000;

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  ScrollController _scrollController;

  AnimationController _animationController;
  Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
              ScrollDirection.reverse &&
          _scrollController.position.activity.velocity > _scrollSensitivity) {
        if (_animationController.isCompleted) {
          _animationController.reverse();
        }
      }
      if (_scrollController.position.userScrollDirection ==
              ScrollDirection.forward &&
          _scrollController.position.activity.velocity < -_scrollSensitivity) {
        if (_animationController.isDismissed) {
          _animationController.forward();
        }
      }
    });

    _animationController = AnimationController(
      duration: Duration(
        milliseconds: 50,
      ),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0, 1),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));
    _scrollController.addListener(scrollListenerWithItemCount);

    itemPositionsListener.itemPositions.addListener(() {
      print(itemPositionsListener.itemPositions);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(scrollListenerWithItemCount);
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void scrollListenerWithItemCount() {
    int itemCount = 100;
    double scrollOffset = _scrollController.position.pixels;
    double viewportHeight = _scrollController.position.viewportDimension;
    double scrollRange = _scrollController.position.maxScrollExtent -
        _scrollController.position.minScrollExtent;
    int firstVisibleItemIndex =
        (scrollOffset / (scrollRange + viewportHeight) * itemCount).floor();
    print(firstVisibleItemIndex);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SlidePanelSheet(
        child: Builder(
          builder: (context) => Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitHeight,
                alignment: Alignment.centerLeft,
                image: AssetImage(
                  "assets/images/background.jpg",
                ),
              ),
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    Hero(
                      tag: "loading",
                      child: Material(
                        color: Colors.transparent,
                        child: GlassContainer.frostedGlass(
                          borderWidth: 0,
                          blur: 6,
                          frostedOpacity: 0.08,
                          height: 64 + MediaQuery.of(context).padding.top,
                          padding: MediaQuery.of(context).padding,
                          width: MediaQuery.of(context).size.width,
                          gradient: LinearGradient(
                            colors: [
                              Colors.teal.withOpacity(0.40),
                              Colors.teal.withOpacity(0.20)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          child: Header(
                            headerTitle: "???",
                            rightAction: [
                              CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    print("click");
                                  },
                                  child: Icon(
                                    Icons.more_vert_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      // child: ListView.builder(
                      //   padding: EdgeInsets.zero,
                      //   controller: _scrollController,
                      //   itemCount: 100,
                      //   itemBuilder: (context, index) => InkWell(
                      //     onTap: () {
                      //       SlidePanelSheet.of(context).openPanel("?????");
                      //     },
                      //     child: GlassContainer.frostedGlass(
                      //       blur: 3,
                      //       height: 200,
                      //       width: 300,
                      //       gradient: LinearGradient(
                      //         colors: [
                      //           Colors.white.withOpacity(0.20),
                      //           Colors.white.withOpacity(0.10)
                      //         ],
                      //         begin: Alignment.topLeft,
                      //         end: Alignment.bottomRight,
                      //       ),
                      //       borderWidth: 0,
                      //       alignment: Alignment.center,
                      //       frostedOpacity: 0.02,
                      //       child: Text("item $index"),
                      //     ),
                      //   ),
                      // ),
                      child: ScrollablePositionedList.builder(
                        itemCount: 500,
                        itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            SlidePanelSheet.of(context).openPanel("?????");
                          },
                          child: GlassContainer.frostedGlass(
                            padding: EdgeInsets.symmetric(
                              vertical: 20,
                            ),
                            blur: 3,
                            height: 200,
                            width: 300,
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.20),
                                Colors.white.withOpacity(0.10)
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(
                              5,
                            ),
                            borderWidth: 0,
                            alignment: Alignment.center,
                            frostedOpacity: 0.02,
                            child: Text("item $index"),
                          ),
                        ),
                        itemScrollController: itemScrollController,
                        itemPositionsListener: itemPositionsListener,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: BottomNav(),
                  ),
                  bottom: 0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
