import 'package:flutter/material.dart';

class UiTools {

  static List<String> _reactionLevelList = ['Clinical relevance absent or weak', 'Oral allergy syndrome','Systemic reaction'];

  static void newSnackBar(String msg, Color color, int duration,context){
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: color,
      duration: Duration(seconds: duration),
    ));
  }


  static String getReactionByLvl(int i) => _reactionLevelList[i];

  static List<String> getReactionLvlList() => _reactionLevelList;




}