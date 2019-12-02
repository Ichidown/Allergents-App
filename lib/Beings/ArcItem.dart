import 'dart:typed_data';

import 'package:flutter/material.dart';

class ArcItem {
  String text;
  Color color;
  double startAngle;
  int id;
  String detail;
  Uint8List image;

  ArcItem(this.text, this.color,this.id,this.detail,this.image);
}