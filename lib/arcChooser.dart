import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'Beings/ArcItem.dart';
import 'Tools/GeneralTools.dart';
import 'Tools/SqliteManager.dart';
import 'main.dart';

typedef void ArcSelectedCallback(int position, ArcItem arcItem);




class ArcChooser extends StatefulWidget {

  ArcSelectedCallback arcSelectedCallback;

  @override
  State<StatefulWidget> createState() {
    return ChooserState(arcSelectedCallback);
  }
}

class ChooserState extends State<ArcChooser> with SingleTickerProviderStateMixin {
  // var slideValue = 200;
  Offset centerPoint;

  double userAngle = 0.0;
  double startAngle;

  //static double center = 270.0;
  //static double centerInRadians = GeneralTools.degreeToRadians(center);


  double angleInRadians,angleInRadiansByTwo,centerItemAngle,itemAngle;


  List<ArcItem> arcItems;

  AnimationController animation;
  double animationStart;
  double animationEnd = 0.0;

  int currentPosition = 0;

  Offset startingPoint;
  Offset endingPoint;

  ArcSelectedCallback arcSelectedCallback;

  ChooserState(ArcSelectedCallback arcSelectedCallback){
    this.arcSelectedCallback = arcSelectedCallback;
  }



  @override
  void initState() {

    arcItems = SqliteManager.getPolens();

    itemAngle = 360/arcItems.length;
    angleInRadians = GeneralTools.degreeToRadians(itemAngle);
    angleInRadiansByTwo = angleInRadians/2;
    //centerItemAngle = GeneralTools.degreeToRadians(center - (itemAngle / 2));



    // initialise startAngle !!!!! DUPLICATE !!!!!
    for (int i = 0; i < arcItems.length; i++) {
      arcItems[i].startAngle = angleInRadiansByTwo + userAngle + (i * angleInRadians);
    }



    animation = new AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    animation.addListener(() {
      userAngle = lerpDouble(animationStart, animationEnd, animation.value);
      setState(() {
        for (int i = 0; i < arcItems.length; i++) {
          arcItems[i].startAngle = angleInRadiansByTwo + userAngle + (i * angleInRadians);
        }
      });
    });
    super.initState();
  }





  @override
  Widget build(BuildContext context) {
    double centerX = MediaQuery.of(context).size.width / 2;
    double centerY = MediaQuery.of(context).size.height * 1.5;
    centerPoint = Offset(centerX, centerY);

    return new GestureDetector(
//        onTap: () {
//          print('ChooserState.build ONTAP');
//          animationStart = touchAngle;
//          animationEnd = touchAngle + angleInRadians;
//          animation.forward(from: 0.0);
//        },
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
        userAngle += freshAngle - startAngle;
        setState(() {
          for (int i = 0; i < arcItems.length; i++) {
            arcItems[i].startAngle = angleInRadiansByTwo + userAngle + (i * angleInRadians);
          }
        });
        startAngle = freshAngle;
      },
      onPanEnd: (DragEndDetails details){

        //find top arc item with Magic!!
        bool rightToLeft = startingPoint.dx<endingPoint.dx;

//        Animate it from this values
        animationStart = userAngle;
        if(rightToLeft) {
          animationEnd +=angleInRadians;
          currentPosition--;
          if(currentPosition<0){
            currentPosition = arcItems.length-1;
          }
        }else{
          animationEnd -=angleInRadians;
          currentPosition++;
          if(currentPosition>=arcItems.length){
            currentPosition = 0;
          }
        }

        if(arcSelectedCallback!=null){
          arcSelectedCallback(currentPosition, arcItems[(currentPosition>=(arcItems.length-1))?0:currentPosition+1]);
        }

        animation.forward(from: 0.0);
      },
      child: CustomPaint(
        size: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.width * 1 / 1.5),
        painter: ChooserPainter(arcItems, angleInRadians),
      ),
    );
  }

}



// draw the arc and other stuff
class ChooserPainter extends CustomPainter {
  //debugging Paint
  final whitePaint = new Paint()
    ..color = Colors.white //Color(0xFFF9D976)
    ..strokeWidth = 1.0
    ..style = PaintingStyle.fill;

  List<ArcItem> arcItems;
  double angleInRadians,angleInRadians1,angleInRadians2,angleInRadians3,angleInRadians4;
  double angleInRadiansByTwo;


  ChooserPainter(List<ArcItem> arcItems, double angleInRadians) {
    this.arcItems = arcItems;
    this.angleInRadians = angleInRadians;
    this.angleInRadiansByTwo = angleInRadians/2;

    angleInRadians1 = angleInRadians/6;
    angleInRadians2 = angleInRadians/3;
    angleInRadians3 = angleInRadians*4/6;
    angleInRadians4 = angleInRadians*5/6;

  }

  @override
  void paint(Canvas canvas, Size size) {
    //common calc
    double centerX = size.width / 2;
    double centerY = size.height * 1.1;
    Offset center = Offset(centerX, centerY);
    double radius = sqrt((size.width * size.width) / 15);

    //for white arc at bottom
    double leftX = centerX - radius;
    double topY = centerY - radius;
    double rightX = centerX + radius;
    double bottomY = centerY + radius;

    //for items
    double radiusItems = radius * 1.3;
    double leftX2 = centerX - radiusItems;
    double topY2 = centerY - radiusItems;
    double rightX2 = centerX + radiusItems;
    double bottomY2 = centerY + radiusItems;

    //for shadow
    double radiusShadow = radius*1.1;
    double leftX3 = centerX - radiusShadow;
    double topY3 = centerY - radiusShadow;
    double rightX3 = centerX + radiusShadow;
    double bottomY3 = centerY + radiusShadow;

    // for text
    double radiusText = radius * 1.15;


    var arcRect = Rect.fromLTRB(leftX2, topY2, rightX2, bottomY2);
    var dummyRect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);

    canvas.clipRect(dummyRect, clipOp: ClipOp.intersect);

    for (int i = 0; i < arcItems.length; i++) {
      canvas.drawArc( arcRect, arcItems[i].startAngle, angleInRadians, true,
          new Paint()
            ..style = PaintingStyle.fill
            //..shader = new LinearGradient(colors: arcItems[i].colors).createShader(dummyRect)
            ..color = arcItems[i].color
      );


      //Draw text
      TextSpan span = new TextSpan(style: new TextStyle(fontWeight: FontWeight.normal, fontSize: 12.0, color: Colors.white), text: arcItems[i].text);
      TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.justify, textDirection: TextDirection.ltr,);
      tp.layout();

      //find additional angle to make text in center
      double f = tp.width/2;
      double t = sqrt((radiusText*radiusText) + (f*f));

      double additionalAngle = acos(((t*t) + (radiusText*radiusText)-(f*f))/(2*t*radiusText));

      double tX = center.dx + radiusText*cos(arcItems[i].startAngle+angleInRadiansByTwo - additionalAngle);// - (tp.width/2);
      double tY = center.dy + radiusText*sin(arcItems[i].startAngle+angleInRadiansByTwo - additionalAngle);// - (tp.height/2);

      canvas.save();
      canvas.translate(tX,tY);




      //print((360/arcItems.length)* (pi / 180));
      canvas.rotate(arcItems[i].startAngle );//+ 1.8





      //print(360/arcItems.length);
      // canvas.rotate( arcItems[i].startAngle + angleInRadians*2 + angleInRadiansByTwo);









      tp.paint(canvas, new Offset(0.0,0.0));
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
        GeneralTools.degreeToRadians(180.0),
        GeneralTools.degreeToRadians(180.0),
        true,
        whitePaint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
































