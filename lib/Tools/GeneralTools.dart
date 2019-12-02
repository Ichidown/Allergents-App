import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:random_color/random_color.dart';

class GeneralTools {

  /// *************************** MATH *****************************/

  static double degreeToRadians(double degree) => degree * (pi / 180);
  static double radianToDegrees(double radian) => radian * (180 / pi);


  /// *************************** IMAGES *****************************/

  static Image imageFromBase64String(String base64String) {
    return Image.memory(base64.decode(base64String));
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }


  /// ***************************** COLORS *****************************/

  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  static String toHex(Color c,{bool leadingHashSign = true}) =>
      '${leadingHashSign ? '0x' : ''}'
      '${c.alpha.toRadixString(16)}'
      '${c.red.toRadixString(16)}'
      '${c.green.toRadixString(16)}'
      '${c.blue.toRadixString(16)}';


  static String getRandomColor() => toHex(new RandomColor().randomColor());


}