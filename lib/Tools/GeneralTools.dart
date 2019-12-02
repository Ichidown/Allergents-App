import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';

class GeneralTools {

  static double degreeToRadians(double degree) => degree * (pi / 180);
  static double radianToDegrees(double radian) => radian * (180 / pi);

  static Image imageFromBase64String(String base64String) {
    return Image.memory(base64.decode(base64String));
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }

}