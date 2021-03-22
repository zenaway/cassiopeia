import 'package:flutter/material.dart';

const double minimizedHeightSize = 64;
const Duration slideAnimationDuration = Duration(milliseconds: 100);

class View extends StatefulWidget {
  final double viewHeight;
  final PageController controller;

  View({
    @required this.viewHeight,
    @required this.controller,
  });

  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> {
  double height = 0;

  @override
  void initState() {
    super.initState();

    height = widget.viewHeight;

    widget.controller.addListener(updateHeight);
  }

  @override
  void dispose() {
    widget.controller.removeListener(updateHeight);
    super.dispose();
  }

  updateHeight() {
    setState(() {
      if ((1 - widget.controller.page) * widget.viewHeight >=
          minimizedHeightSize) {
        height = (1 - widget.controller.page) * widget.viewHeight;
      } else {
        height = 64;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.maxFinite,
      color: Colors.black.withOpacity(
        0.7,
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, constraints) {
          if (constraints.maxHeight > minimizedHeightSize * 2) {
            return SafeArea(
              child: Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.width / 2 * 3,
                        minHeight: minimizedHeightSize,
                        maxWidth: MediaQuery.of(context).size.width,
                      ),
                      child: AspectRatio(
                        aspectRatio: 3 / 2,
                        child: Container(
                          color: Colors.white,
                          child: Text("???"),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Placeholder(),
                  ),
                ],
              ),
            );
          } else {
            return Row(
              children: [
                AspectRatio(
                  aspectRatio: 3 / 2,
                  child: Container(
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: Placeholder(),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
