import 'package:cassiopeia/widget/bottomNav.dart';
import 'package:cassiopeia/widget/header.dart';
import 'package:cassiopeia/widget/slidePanelSheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:glass_kit/glass_kit.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final int _scrollSensitivity = 2000;

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
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
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
            child: SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Hero(
                        tag: "loading",
                        child: Material(
                          color: Colors.teal,
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
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: List.generate(
                                2,
                                (index) => InkWell(
                                  onTap: () {
                                    SlidePanelSheet.of(context)
                                        .openPanel("?????");
                                  },
                                  child: GlassContainer.frostedGlass(
                                    blur: 12,
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
                                    borderWidth: 0,
                                    alignment: Alignment.center,
                                    frostedOpacity: 0.02,
                                    child: Text("???"),
                                  ),
                                ),
                              ),
                            ),
                          ),
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
      ),
    );
  }
}
