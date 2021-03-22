import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:simple_throttle_debounce/simple_throttle_debounce.dart';

const double bottomNavHeight = 50;

class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> with TickerProviderStateMixin {
  final List<Widget> bottomListMenu = [
    BottomNavItem(
      onTab: () {},
      navItemWidth: 50,
      child: Text(
        "HOME",
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    ),
    // BottomNavItem(
    //   onTab: () {},
    //   navItemWidth: 50,
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       Text(
    //         "관심",
    //         style: TextStyle(
    //           color: Colors.white,
    //           fontSize: 12,
    //         ),
    //       ),
    //       Text(
    //         "그룹",
    //         style: TextStyle(
    //           color: Colors.white,
    //           fontSize: 12,
    //         ),
    //       ),
    //     ],
    //   ),
    // ),
    // BottomNavItem(
    //   onTab: () {},
    //   navItemWidth: 50,
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       Text(
    //         "주식",
    //         style: TextStyle(
    //           color: Colors.white,
    //           fontSize: 12,
    //         ),
    //       ),
    //       Text(
    //         "현재가",
    //         style: TextStyle(
    //           color: Colors.white,
    //           fontSize: 12,
    //         ),
    //       ),
    //     ],
    //   ),
    // ),
    // BottomNavItem(
    //   onTab: () {},
    //   navItemWidth: 50,
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       Text(
    //         "주식",
    //         style: TextStyle(
    //           color: Colors.white,
    //           fontSize: 12,
    //         ),
    //       ),
    //       Text(
    //         "주문",
    //         style: TextStyle(
    //           color: Colors.white,
    //           fontSize: 12,
    //         ),
    //       ),
    //     ],
    //   ),
    // ),
    // BottomNavItem(
    //   onTab: () {},
    //   navItemWidth: 70,
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       Text(
    //         "국내주식",
    //         style: TextStyle(
    //           color: Colors.white,
    //           fontSize: 12,
    //         ),
    //       ),
    //       Text(
    //         "잔고/손익",
    //         style: TextStyle(
    //           color: Colors.white,
    //           fontSize: 12,
    //         ),
    //       ),
    //     ],
    //   ),
    // ),
    // BottomNavItem(
    //   onTab: () {},
    //   navItemWidth: 50,
    //   child: Text(
    //     "이체",
    //     style: TextStyle(
    //       color: Colors.white,
    //       fontSize: 12,
    //     ),
    //   ),
    // ),
    // BottomNavItem(
    //   onTab: () {},
    //   navItemWidth: 50,
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       Text(
    //         "이체",
    //         style: TextStyle(
    //           color: Colors.white,
    //           fontSize: 12,
    //         ),
    //       ),
    //       Text(
    //         "뉴스",
    //         style: TextStyle(
    //           color: Colors.white,
    //           fontSize: 12,
    //         ),
    //       ),
    //     ],
    //   ),
    // ),
  ];
  final Duration _animationDuration = Duration(
    milliseconds: 100,
  );
  ScrollController _scrollController;
  AnimationController _animationLeftController;
  AnimationController _animationRightController;
  Animation<double> _fadeAnimationLeft;
  Animation<double> _fadeAnimationRight;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _animationLeftController = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );
    _animationRightController = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );

    _fadeAnimationLeft = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _animationLeftController,
      curve: Curves.linear,
    ));

    _fadeAnimationRight = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _animationRightController,
      curve: Curves.linear,
    ));

    dynamic debounceAnimation = debounce(() {
      _animationLeftController.reverse();
      _animationRightController.reverse();
    }, 1500);

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _animationLeftController.forward();
    //   _animationRightController.forward();
    //   if (_scrollController.position.atEdge) {
    //     if (_scrollController.position.pixels == 0.0) {
    //       _animationLeftController.reverse();
    //     } else {
    //       _animationRightController.reverse();
    //     }
    //   } else {
    //     _animationLeftController.forward();
    //     _animationRightController.forward();
    //   }
    //   debounceAnimation();
    // });

    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels == 0.0) {
          _animationLeftController.reverse();
        } else {
          _animationRightController.reverse();
        }
      } else {
        _animationLeftController.forward();
        _animationRightController.forward();
      }
      debounceAnimation();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationLeftController.dispose();
    _animationRightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.grey[850],
      height: bottomNavHeight,
      width: size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BottomNavItem(
            onTab: () => Navigator.pushReplacementNamed(context, "/"),
            child: SizedBox(
              width: 50,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 4,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_outline,
                      color: Colors.orange[300],
                    ),
                    Text(
                      "로그인",
                      style: TextStyle(
                        color: Colors.orange[300],
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          VerticalDivider(
            thickness: 1,
            width: 1,
            color: Colors.white10,
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                ListView.separated(
                  controller: _scrollController,
                  itemCount: bottomListMenu.length,
                  itemBuilder: (context, index) => bottomListMenu[index],
                  separatorBuilder: (context, index) => VerticalDivider(
                    thickness: 1,
                    width: 1,
                    color: Colors.white10,
                  ),
                  scrollDirection: Axis.horizontal,
                ),
                Positioned(
                  child: FadeTransition(
                    opacity: _fadeAnimationLeft,
                    child: Icon(
                      Icons.arrow_left,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  left: 0,
                ),
                Positioned(
                  child: FadeTransition(
                    opacity: _fadeAnimationRight,
                    child: Icon(
                      Icons.arrow_right,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  right: 0,
                ),
              ],
            ),
          ),
          VerticalDivider(
            thickness: 1,
            width: 1,
            color: Colors.white10,
          ),
          BottomNavItem(
            onTab: () => print("메뉴 클릭"),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 4,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.menu,
                    color: Colors.orange[300],
                  ),
                  Text(
                    "전체메뉴",
                    style: TextStyle(
                      color: Colors.orange[300],
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final double navItemWidth;
  final Function onTab;
  final Widget child;

  BottomNavItem({
    this.child,
    this.onTab,
    this.navItemWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTab,
        child: Container(
          alignment: Alignment.center,
          height: bottomNavHeight,
          width: navItemWidth,
          child: child,
        ),
      ),
    );
  }
}
