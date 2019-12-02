import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'Beings/ArcItem.dart';
import 'Tools/GeneralTools.dart';
import 'Tools/database_helper.dart';

typedef void ArcSelectedCallback(int position, ArcItem arcItem);

class ArcChooser extends StatefulWidget {
  ArcSelectedCallback arcSelectedCallback;
  // _DemonstrationPageState _demonstrationPageState;

  ArcChooser({Key key,this.onChoiceChange,this.onChoiceSelected}): super(key: key);

  var onChoiceChange,onChoiceSelected;

  @override
  State<StatefulWidget> createState() {
    return ChooserState(arcSelectedCallback, onChoiceChange, onChoiceSelected);
  }
}

class ChooserState extends State<ArcChooser> with SingleTickerProviderStateMixin {

  ChooserState(this.arcSelectedCallback, this.onChoiceChange, this.onChoiceSelected);
  var onChoiceChange,onChoiceSelected;

  Offset centerPoint;

  double userAngle = 0.0;
  double startAngle;

  double angleInRadians, centerItemAngle;
  double angleInRadiansByTwo;

  List<ArcItem> arcItems = List<ArcItem>();

  AnimationController animation;
  double animationStart;
  double animationEnd = 0.0;

  int currentPosition = 0;

  Offset startingPoint;
  Offset endingPoint;

  ArcSelectedCallback arcSelectedCallback;

  final dbHelper = DatabaseHelper.instance;

  var colorLvl = [Colors.greenAccent,Colors.amberAccent,Colors.redAccent];

  int currentDataChoiceLvl = 0;
  int id1 = 0, id2 = 0;




  @override
  void initState() {

    animation = new AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    animation.addListener(() {
      userAngle = lerpDouble(animationStart, animationEnd, animation.value);
      refreshRouletteWheelRotation(); // UPDATE THIS TO MAKE THE ANIMATION CONTINUE TO THE NORMAL FINISH LOCATION
    });

    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {

    double centerX = MediaQuery.of(context).size.width / 2;
    double centerY = MediaQuery.of(context).size.height * 1.5;
    centerPoint = Offset(centerX, centerY);


    return GestureDetector(
      onTap: () {
        onChoiceSelected(arcItems[currentPosition].id);
      },


      onPanStart: (DragStartDetails details) {
        startingPoint = details.globalPosition;
        var deltaX = centerPoint.dx - details.globalPosition.dx;
        var deltaY = centerPoint.dy - details.globalPosition.dy;
        startAngle = atan2(deltaY, deltaX);
      },


      onPanUpdate: (DragUpdateDetails details) {
        endingPoint = details.globalPosition;
        var deltaX = centerPoint.dx - details.globalPosition.dx;
        var deltaY = centerPoint.dy - details.globalPosition.dy;
        var freshAngle = atan2(deltaY, deltaX);
        userAngle += (freshAngle - startAngle) * 0.3;
        refreshRouletteWheelRotation();
        startAngle = freshAngle;
      },


      onPanEnd: (DragEndDetails details) {
        //find top arc item
        bool rightToLeft = startingPoint.dx < endingPoint.dx;

        //Animate it from this values
        animationStart = userAngle;
        if (rightToLeft) {
          animationEnd += angleInRadians;
          currentPosition--;
          if (currentPosition < 0) {
            currentPosition = arcItems.length - 1;
          }
        } else {
          animationEnd -= angleInRadians;
          currentPosition++;
          if (currentPosition >= arcItems.length) {
            currentPosition = 0;
          }
        }

        if (arcSelectedCallback != null) {
          arcSelectedCallback(
              currentPosition,
              arcItems[(currentPosition >= (arcItems.length - 1))
                  ? 0
                  : currentPosition + 1]);
        }
        animation.forward(from: 0.0);
        if (arcItems.length > 0)
          onChoiceChange(arcItems[currentPosition].text,arcItems[currentPosition].detail,arcItems[currentPosition].image); // update DemonstrationPage main choice text
        else onChoiceChange('','',null);
      },


      child: arcItems.length > 0 ? CustomPaint(
        size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height * 1 / 1.5),
        painter: ChooserPainter(arcItems, angleInRadians, MediaQuery.of(context).size.height, MediaQuery.of(context).size.width,MediaQuery.of(context).orientation),
      ) : Container(),
    );
  }


  void refreshRouletteWheelRotation() {
    setState(() {
      for (int i = 0; i < arcItems.length; i++) {
        arcItems[i].startAngle = angleInRadiansByTwo + userAngle + (i * angleInRadians);
      }
    });
  }


  void getAllergene(int type){ // 0 == pollens, 1 == aliments
    dbHelper.getAllergeneOfType(type).then((result) {
      setState(() {
        arcItems = result.length>0 ? result.map((c) => ArcItem(c.name,Color(int.parse(c.color)),c.id,c.crossGroup,c.image)).toList() : List<ArcItem>();
      });
      refreshRouletteWheelData();
    });
  }


  void getMolecularFamilies(int allergeneId1,int allergeneId2){ // 0 == pollens, 1 == aliments
    dbHelper.getMolecularFamiliesOfAllergeneCombination(allergeneId1,allergeneId2).then((result) {
      setState(() {
        arcItems = result.length>0 ? result.map((c) => ArcItem(c.name,Color(int.parse(c.color)),c.id, c.occurrenceFrequency==-1?'Unknown%':"(${c.occurrenceFrequency}%)",null)).toList() : List<ArcItem>();
      });
      refreshRouletteWheelData();
    });
  }


  void getMolecularAllergenes(int mFamilyId){ // 0 == pollens, 1 == aliments
    dbHelper.getMolecularAllergenesFromMFamily(mFamilyId).then((result) {
      setState(() {
        arcItems = result.length>0 ? result.map((c) => ArcItem(c.name,Color(int.parse(c.color)),c.id,'',null)).toList() : List<ArcItem>();
      });
      refreshRouletteWheelData();
    });
  }

  void getReactions(int mAllergeneId){ // 0 == pollens, 1 == aliments
    dbHelper.getReactionsOfMolecularAllergenes(mAllergeneId).then((result) {
      setState(() {
        arcItems = result.length>0 ? result.map((c) => ArcItem(c.adapted_treatment,colorLvl[c.level],c.id,'',null)).toList() : List<ArcItem>();
      });
      refreshRouletteWheelData();
    });
  }

  void refreshRouletteWheelData(){
    angleInRadians = GeneralTools.degreeToRadians(arcItems.length>0? 360 / arcItems.length:0);
    angleInRadiansByTwo = angleInRadians / 2;
    refreshRouletteWheelRotation();
    if(arcItems.length>0) onChoiceChange(arcItems[currentPosition].text,arcItems[currentPosition].detail,arcItems[currentPosition].image); // initial choice when started app / demonstration page
    else onChoiceChange('','',null);
  }

  void setData(int choiceLvl, int id1, int id2){
    currentDataChoiceLvl = choiceLvl;
    this.id1 = id1;
    this.id2 = id2;
    getData();
  }


  void getData(){
    switch(currentDataChoiceLvl){
      case 0: getAllergene(0); break;
      case 1: getAllergene(1); break;
      case 2: getMolecularFamilies(id1,id2); break;
      case 3: getMolecularAllergenes(id1); break;
      case 4: getReactions(id1); break;
    }
  }



}














// draw the arc and other stuff
class ChooserPainter extends CustomPainter {
  //debugging Paint
  final whitePaint = new Paint()
    ..color = Colors.white //Color(0xFFF9D976)
    ..strokeWidth = 1.0
    ..style = PaintingStyle.fill;
  double screenHeight,screenWidth;

  List<ArcItem> arcItems;
  double angleInRadians, angleInRadians1, angleInRadians2, angleInRadians3, angleInRadians4,angleInRadiansByTwo;

  Orientation screenOrientation;

  ChooserPainter(List<ArcItem> arcItems, double angleInRadians, this.screenHeight,this.screenWidth,this.screenOrientation) {
    this.arcItems = arcItems;
    this.angleInRadians = angleInRadians;
    this.angleInRadiansByTwo = angleInRadians / 2;


    angleInRadians1 = angleInRadians / 6;
    angleInRadians2 = angleInRadians / 3;
    angleInRadians3 = angleInRadians * 4 / 6;
    angleInRadians4 = angleInRadians * 5 / 6;
  }

  @override
  void paint(Canvas canvas, Size size) {
    //common calc
    double centerX = size.width / 2;
    double centerY = screenOrientation == Orientation.landscape? screenWidth:screenHeight;//size.height * 1.1;

    print(screenHeight.toString());

    Offset center = Offset(centerX, centerY);
    double radius = sqrt((size.width * size.width) / 3);

    //for white arc at bottom
    double whiteArcRadius = radius * 0.95;
    double leftX = (centerX - whiteArcRadius);
    double topY = (centerY - whiteArcRadius);
    double rightX = (centerX + whiteArcRadius);
    double bottomY = (centerY + whiteArcRadius);

    //for items
    double radiusItems = radius * 1.13;
    double leftX2 = centerX - radiusItems;
    double topY2 = centerY - radiusItems;
    double rightX2 = centerX + radiusItems;
    double bottomY2 = centerY + radiusItems;

    //for shadow
    double radiusShadow = radius * 1.05;
    double leftX3 = centerX - radiusShadow;
    double topY3 = centerY - radiusShadow;
    double rightX3 = centerX + radiusShadow;
    double bottomY3 = centerY + radiusShadow;

    // for text
    double radiusText = radius * 1.05;

    Rect arcRect = Rect.fromLTRB(leftX2, topY2, rightX2, bottomY2);

    Rect dummyRect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);

    canvas.clipRect(dummyRect, clipOp: ClipOp.intersect);

    for (int i = 0; i < arcItems.length; i++) {
      canvas.drawArc(
          arcRect,
          arcItems[i].startAngle,
          angleInRadians,
          true,
          new Paint()
            ..style = PaintingStyle.fill
            ..color = arcItems[i].color);

      //Draw text
      TextSpan span = new TextSpan(text: arcItems[i].text,
          style: new TextStyle(fontWeight: FontWeight.normal, fontSize: 12.0, color: Colors.white));
      TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.justify, textDirection: TextDirection.ltr,);
      tp.layout();

      //find additional angle to make text in center
      double f = tp.width / 2;
      double t = sqrt((radiusText * radiusText) + (f * f));

      double additionalAngle = acos(((t * t) + (radiusText * radiusText) - (f * f)) / (2 * t * radiusText));

      double tX = center.dx + radiusText * cos(arcItems[i].startAngle + angleInRadiansByTwo - additionalAngle); // - (tp.width/2);
      double tY = center.dy + radiusText * sin(arcItems[i].startAngle + angleInRadiansByTwo - additionalAngle); // - (tp.height/2);

      canvas.save();
      canvas.translate(tX, tY);

      //print((360/arcItems.length)* (pi / 180));

      /** KEEP THIS ONE IN CASE YOU WANT A BETTER TEXT ROTATION **/
      /** canvas.rotate(arcItems[i].startAngle); **/

      //print(360/arcItems.length);
      /**canvas.rotate( arcItems[i].startAngle + angleInRadians*2 + angleInRadiansByTwo);*/

      tp.paint(canvas, new Offset(0.0, 0.0));
      canvas.restore();
    }

    //shadow
    Path shadowPath = new Path();
    shadowPath.addArc(
        Rect.fromLTRB(leftX3, topY3, rightX3, bottomY3),
        GeneralTools.degreeToRadians(180.0),
        GeneralTools.degreeToRadians(180.0));
    canvas.drawShadow(shadowPath, Colors.blueGrey[900], 15.0, true);

    //bottom white arc
    canvas.drawArc(
        Rect.fromLTRB(leftX, topY, rightX, bottomY),
        GeneralTools.degreeToRadians(360.0),
        GeneralTools.degreeToRadians(360.0),
        true,
        whitePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }




}
