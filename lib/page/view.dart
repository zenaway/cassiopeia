import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

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
  int verticalContentsFlex = 65;
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
      verticalContentsFlex = (65 - widget.controller.page * 65).round();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: Colors.black,
      child: SafeArea(
        top: verticalContentsFlex > 64,
        child: Column(
          children: [
            Expanded(
              flex: 35,
              child: Row(
                children: [
                  Expanded(
                    flex: 35,
                    child: Container(
                      color: Colors.black,
                    ),
                    // child: YoutubePlayerIFrame(
                    //   controller: _controller,
                    //   aspectRatio: 3 / 2,
                    // ),
                  ),
                  if (verticalContentsFlex < 15)
                    Expanded(
                      flex: ((15 - verticalContentsFlex) * 6.5).toInt(),
                      child: Opacity(
                        opacity: (1.0 - verticalContentsFlex / 15),
                        child: Container(
                          color: Colors.white,
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () {
                                print("??");
                              },
                              child: Text("????"),
                            ),
                          ),
                          // color: Colors.white
                          //     .withOpacity((10 - verticalContentsFlex) / 10),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (verticalContentsFlex > 15)
              Expanded(
                flex: verticalContentsFlex,
                child: Opacity(
                  opacity: verticalContentsFlex / 65,
                  child: Container(
                    color: Colors.white,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          print("??");
                        },
                        child: Text("????"),
                      ),
                    ),
                    // color:
                    //     Colors.white.withOpacity((65 - verticalContentsFlex) / 100),
                  ),
                ),
              ),
          ],
        ),
      ),
      // child: SizeTransition(
      //   sizeFactor: CurvedAnimation(
      //     curve: Curves.linear,
      //     parent: _sizeController,
      //   ),
      //   child: Image.asset("assets/images/logo.png"),
      // ),
    );
  }
}
