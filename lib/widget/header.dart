import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String headerTitle;
  final List<Widget> leftAction;
  final List<Widget> rightAction;
  final Widget bottomWidget;
  final Color headerColor;

  Header({
    @required this.headerTitle,
    this.leftAction,
    this.rightAction,
    this.bottomWidget,
    this.headerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: headerColor,
        border: Border(
          bottom: BorderSide(
            color: Colors.white38,
          ),
        ),
      ),
      height: 64,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 4,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: leftAction ?? [],
                    ),
                    Row(
                      children: rightAction ?? [],
                    ),
                  ],
                ),
                Text(
                  headerTitle,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            if (bottomWidget != null) bottomWidget,
          ],
        ),
      ),
    );
  }
}
