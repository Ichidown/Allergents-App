import 'package:flutter/material.dart';
import 'package:custom_splash/custom_splash.dart';
import 'package:flutter/services.dart';
import 'Pages/DemonstrationPage.dart';

Future<void> main() async {

  /**await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);*/



  runApp(MaterialApp(
    home: CustomSplash(
      imagePath: 'assets/images/astroLabe-Logo.png',
      backGroundColor: Color.fromRGBO(20, 20, 30, 1),
      animationEffect: 'zoom-in',
      home: DemonstrationPage(),
      duration: 2300,
      type: CustomSplashType.StaticDuration,
    ),
  ));

  // force landscape screen orientation
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,]);

}