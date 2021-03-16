import 'package:cassiopeia/page/home.dart';
import 'package:cassiopeia/page/login.dart';
import 'package:cassiopeia/page/naverMap.dart';
import 'package:cassiopeia/page/success.dart';
import 'package:flutter/material.dart';

class AppMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (_) => Login(),
        "/loading": (_) => Success(),
        "/home": (_) => Home(),
        "/naver": (_) => NaverMap(),
      },
    );
  }
}
