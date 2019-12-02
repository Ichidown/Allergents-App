import 'package:flutter/material.dart';
import 'package:custom_splash/custom_splash.dart';
import 'Pages/DemonstrationPage.dart';

void main() {
  runApp(MaterialApp(
    home: CustomSplash(
      imagePath: 'assets/images/Logo.png',
      backGroundColor: Color.fromRGBO(20, 20, 30, 1),
      animationEffect: 'zoom-in',
      home: DemonstrationPage(),
      //customFunction: duringSplash,
      duration: 2300,
      type: CustomSplashType.StaticDuration,
    ),
  ));
}