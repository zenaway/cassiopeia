import 'package:flutter/material.dart';

class Success extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(
        Duration(milliseconds: 300),
      );
      Navigator.pushReplacementNamed(context, "/home");
    });
    final Size size = MediaQuery.of(context).size;
    return Hero(
      tag: "loading",
      child: Container(
        width: size.width,
        height: size.height,
        color: Colors.teal,
        // child: SizedBox(
        //   height: 100,
        //   width: 100,
        //   child: Image.asset("assets/images/logo.png"),
        // ),
      ),
    );
  }
}
