import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'Beings/ArcItem.dart';
import 'Tools/GeneralTools.dart';
import 'Tools/UiTools.dart';
import 'Tools/database_helper.dart';

typedef void ArcSelectedCallback(int position, ArcItem arcItem);

class ArcChooser extends StatefulWidget {
  ArcSelectedCallback arcSelectedCallback;

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
  double animationStart = 0.0;
  double animationEnd = 0.0;

  int currentPosition = 0;

  Offset startingPoint;
  Offset endingPoint;

  ArcSelectedCallback arcSelectedCallback;

  final dbHelper = DatabaseHelper.instance;

  var colorLvl = [Colors.greenAccent,Colors.amberAccent,Colors.redAccent];

  int currentDataChoiceLvl = 0;
  int id1 = 0, id2 = 0, id3 = 0;




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
        //print(arcItems[currentPosition].id);
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


      child: arcItems.length > 0 ?

      CustomPaint(
        size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height * 1 / 1.5),
        painter: ChooserPainter(arcItems, angleInRadians, MediaQuery.of(context).size.height, MediaQuery.of(context).size.width,MediaQuery.of(context).orientation),
      )


          : Container(),
    );
  }







  void refreshRouletteWheelRotation() {
    setState(() {
      //print(arcItems.length/angleInRadiansByTwo);
      //userAngle = 0;
      double magicNumber = GeneralTools.degreeToRadians(GeneralTools.radianToDegrees(angleInRadians)*arcItems.length/2 -(GeneralTools.radianToDegrees(angleInRadians)/2));
      for (int i = 0; i < arcItems.length; i++) {
        arcItems[i].startAngle =  1.6 + magicNumber /*GeneralTools.degreeToRadians(0)*/ + /**angleInRadiansByTwo*arcItems.length +*/ userAngle + (i * angleInRadians)/** + 4.65*/;// + 10.88;
      }
      //print(arcItems[0].startAngle);
    });
  }







  void getAllergen(int type){ // 0 == pollens, 1 == aliments
    dbHelper.getAllergenOfType(type).then((result) {
      setState(() {
        arcItems = result.length>0 ? result.map((c) => ArcItem(c.name,Color(int.parse(c.color)),c.id,c.crossGroup,c.image)).toList() : List<ArcItem>();
        // userAngle = 0;
        // startAngle = 0;
        // currentPosition = 0;
      });
      refreshRouletteWheelData();
    });
  }


  void getMolecularFamilies(int allergenId1,int allergenId2){ // 0 == pollens, 1 == aliments
    dbHelper.getMolecularFamiliesOfAllergenCombination(allergenId1,allergenId2).then((result) {
      setState(() {
        arcItems = result.length>0 ? result.map((c) => ArcItem(c.name,Color(int.parse(c.color)),c.id, c.occurrenceFrequency==-1?'Inconu%':"(${c.occurrenceFrequency}%)",null)).toList() : List<ArcItem>();
        // userAngle = 0;
        // startAngle = 0;
        // currentPosition = 0;
      });
      refreshRouletteWheelData();
    });
  }


  void getMolecularAllergens(int mFamilyId, int pollenId, int alimentId){ // 0 == pollens, 1 == aliments
    dbHelper.getMolecularAllergensFromMFamily(mFamilyId,pollenId,alimentId).then((result) {
      setState(() {
        arcItems = result.length>0 ? result.map((c) => ArcItem(c.name,Color(int.parse(c.color)),c.id,'',null)).toList() : List<ArcItem>();
        // userAngle = 0;
        // startAngle = 0;
        // currentPosition = 0;
      });
      refreshRouletteWheelData();
    });
  }

  void getReactions(int mAllergenId){ // 0 == pollens, 1 == aliments
    dbHelper.getReactionsOfMolecularAllergens(mAllergenId).then((result) {
      setState(() {
        arcItems = result.length>0 ? result.map((c) => ArcItem(UiTools.getReactionByLvl(c.level),colorLvl[c.level],c.id,c.adaptedTreatment,null)).toList() : List<ArcItem>();
        // userAngle = 0;
        // startAngle = 0;
        //currentPosition = 0;
      });
      refreshRouletteWheelData();
    });
  }

  void refreshRouletteWheelData(){
    angleInRadians = GeneralTools.degreeToRadians(arcItems.length>0? 360 / arcItems.length:0);
    angleInRadiansByTwo = angleInRadians / 2;

    userAngle = 0;
    // startAngle = 0;
    currentPosition = 0;

    animationStart = 0;
    animationEnd = 0;

    refreshRouletteWheelRotation();

    if(arcItems.length>0) onChoiceChange(arcItems[currentPosition].text,arcItems[currentPosition].detail,arcItems[currentPosition].image); // initial choice when started app / demonstration page
    else onChoiceChange('','',null);
  }

  void setData(int choiceLvl, int id1, int id2, int id3){
    currentDataChoiceLvl = choiceLvl;
    this.id1 = id1;
    this.id2 = id2;
    this.id3 = id3;
    getData();
  }


  void getData(){
    switch(currentDataChoiceLvl){
      case 0: getAllergen(0); break;
      case 1: getAllergen(1); break;
      case 2: getMolecularFamilies(id1,id2); break;
      case 3: getMolecularAllergens(id1,id2,id3); break;
      case 4: getReactions(id1); break;
    }
    setState(() { // reset wheel rotation
      /**userAngle = 0;*/
      currentPosition = 0;
    });

  }



}














// draw the arc and other stuff
class ChooserPainter extends CustomPainter {
  //debugging Paint
  final whitePaint = new Paint()
    ..color = Color(0x30000000)
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
    double centerY = (screenOrientation == Orientation.landscape)? screenWidth/1.07:screenHeight;//size.height * 1.1;

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
    double radiusText = radius * 1.07;

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
      int textAcceptableLength = (500/arcItems.length).round();// set text max length depending on the number of items
      TextSpan span = new TextSpan(
          text: arcItems[i].text.length>textAcceptableLength?
            "${arcItems[i].text.substring(0,textAcceptableLength)}\n-${arcItems[i].text.substring(textAcceptableLength)}":
            arcItems[i].text,
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0, color: Colors.white));
      TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.justify, textDirection: TextDirection.ltr,
          textScaleFactor:min(0.7 + 5/(arcItems.length), 1.5) );
      tp.layout();

      //find additional angle to make text in center
      double f = tp.width / 2;
      double t = sqrt((radiusText * radiusText) + (f * f));

      double additionalAngle = acos(((t * t) + (radiusText * radiusText) - (f * f)) / (2 * t * radiusText));

      double tX = center.dx + radiusText * cos(arcItems[i].startAngle + angleInRadiansByTwo - additionalAngle); // - (tp.width/2);
      double tY = center.dy + radiusText * sin(arcItems[i].startAngle + angleInRadiansByTwo - additionalAngle); // - (tp.height/2);

      canvas.save();
      canvas.translate(tX, tY);

      /** KEEP THIS ONE IN CASE YOU WANT A BETTER TEXT ROTATION **/
      /** canvas.rotate(arcItems[i].startAngle); **/

      canvas.rotate( arcItems[i].startAngle + angleInRadians*(arcItems.length/4.1 /** Magic number **/) + angleInRadiansByTwo);

      tp.paint(canvas, new Offset(0.0, 0.0));
      canvas.restore();
    }

    //shadow
    Path shadowPath = new Path();
    shadowPath.addArc(
        Rect.fromLTRB(leftX3, topY3, rightX3, bottomY3),
        GeneralTools.degreeToRadians(180.0),
        GeneralTools.degreeToRadians(180.0));
    canvas.drawShadow(shadowPath, Colors.black, 15.0, true);





    //bottom white arc
    canvas.drawArc(
        Rect.fromLTRB(leftX, topY, rightX, bottomY),
        GeneralTools.degreeToRadians(360.0),
        GeneralTools.degreeToRadians(360.0),
        true,
        whitePaint);


    //canvas.clipRRect(RRect.fromLTRBR(leftX, topY, rightX, bottomY,/*center,*/Radius.circular(100)),doAntiAlias: true);



  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }




}
