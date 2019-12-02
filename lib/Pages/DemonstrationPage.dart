
import 'dart:typed_data';

import 'package:allergensapp/Beings/Conclusion.dart';
import 'package:allergensapp/Tools/database_helper.dart';

import '../Pages/Dialogs/ConclusionDialog.dart';
import 'package:flutter/material.dart';
import '../arcChooser.dart';
import 'CmsPage.dart';
import 'AboutAppPage.dart';


class DemonstrationPage extends StatefulWidget {
  static const String routeName = '/demonstration';

  @override
  _DemonstrationPageState createState() => _DemonstrationPageState();
}

class _DemonstrationPageState extends State<DemonstrationPage> with SingleTickerProviderStateMixin {
  final GlobalKey<ChooserState> _arcChooserkey = GlobalKey();

  final dbHelper = DatabaseHelper.instance;

  final int btnAnimationDuration = 200;
  AnimationController buttonsAnimationCon;
  Animation btnAnimation;
  bool allergeneBtnOpen = false;
  bool pollenBtnOpen = false;
  bool mFamilyBtnOpen = false;
  bool mAllergeneBtnOpen = false;

  final double animatedBtnOpenSize = 180;
  final double animatedBtnClosedSize = 10;
  final double buttonHeight = 30;

  final String appTitle = 'Astrolabe Allergens App';
  //final String drawerTabTitle = 'Database Management';
  final String tab2Text = 'Content Management System';
  final String tab3Text = 'About The App';

  String choiceTitle = '';
  String choiceSubTitle = '';

  String pollenBtnText = '';
  String alimentsBtnText = '';
  String mFamilyBtnText = '';
  String mAllergeneBtnText = '';

  int activatedBtnNumber= 0;
  ArcChooser arcChooser;

  int pollenId,alimentId,mFamilyId,mAllergenId,reactionId;

  PageController imageViewController = PageController(initialPage: 1);

  ImageProvider currentBgImage;
  ImageProvider allergensImage = AssetImage("assets/images/i89767-.jpg");
  ImageProvider molecularFamilyImage = AssetImage("assets/images/mollecular families.jpg");
  ImageProvider molecularAllergeneImage = AssetImage("assets/images/mollecular allergens.jpg");
  ImageProvider reactionImage = AssetImage("assets/images/reaction.jpg");
  ImageProvider appCardImage = AssetImage("assets/images/card.jpg");



  @override
  void initState() {
    buttonsAnimationCon = AnimationController(vsync: this,duration: Duration(microseconds: 300));
    btnAnimation = Tween(begin: 1.0, end: 0.5).animate(CurvedAnimation(parent: buttonsAnimationCon,curve: Curves.easeInOut));
    currentBgImage = allergensImage;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    arcChooser = ArcChooser( key: _arcChooserkey,
        onChoiceChange: (String text, String detail, Uint8List image) {
          setState(() {
            choiceTitle = text;
            choiceSubTitle = detail;

            if (activatedBtnNumber<2){
              if(image==null){
                currentBgImage = allergensImage;
              }

              else {
                currentBgImage = MemoryImage(image);
              }
            }

          });
        },
        onChoiceSelected: (int itemId){
          if(choiceTitle.length>0) // to block buttons interaction when no selectable element exist
            setState(() {
              if(activatedBtnNumber<5)activatedBtnNumber++;
              switch(activatedBtnNumber){
                case 1:
                  pollenBtnText = choiceTitle;
                  pollenId=itemId;
                  _arcChooserkey.currentState.setData(activatedBtnNumber,1,0);
                  break;
                case 2:
                  alimentsBtnText = choiceTitle;
                  alimentId=itemId;
                  _arcChooserkey.currentState.setData(activatedBtnNumber,pollenId,alimentId);
                  currentBgImage = molecularFamilyImage;
                  break;
                case 3:
                  mFamilyBtnText = choiceTitle;
                  mFamilyId=itemId;
                  _arcChooserkey.currentState.setData(activatedBtnNumber,mFamilyId,0);
                  currentBgImage = molecularAllergeneImage;
                  break;
                case 4:
                  mAllergeneBtnText = choiceTitle;
                  mAllergenId=itemId;
                  _arcChooserkey.currentState.setData(activatedBtnNumber,mAllergenId,0);
                  currentBgImage = reactionImage;
                  break;
                case 5:
                  reactionId=itemId;
                  showDialog(context: context, builder: (context) {
                  return ConclusionDialog(dbHelper.getConclusion(pollenId, alimentId, mFamilyId, mAllergenId, reactionId));}).then((onValue) {});
                  break;
              }
            });
        });

    return
      Scaffold(
          drawer: Drawer(child: ListView(padding: EdgeInsets.zero ,children: <Widget>[
            DrawerHeader(child: Container(),decoration: BoxDecoration(color: Colors.blue,image: DecorationImage(image: appCardImage,fit: BoxFit.cover)),
              /**child: Text(drawerTabTitle,style: TextStyle(color: Colors.white,fontSize: 20),),*/ ),

            new ListTile(title: Text(tab2Text),onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => CmsPage(onAllergensChangeEvent)));}),

            new ListTile(title: Text(tab3Text),onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AboutAppPage()));}),

          ],),),

          appBar: PreferredSize( preferredSize: Size.fromHeight(40.0),
              child : AppBar(
                title: Text(appTitle),
                centerTitle: true,
              )),

          body:
          Column(children: <Widget>[


          Expanded(child:
          Stack(children: <Widget>[

          Container(
            decoration: BoxDecoration(
              image: DecorationImage( image: currentBgImage, fit: BoxFit.cover,),
            ),
          ),


            IgnorePointer( child: Container(color: Color.fromRGBO(0, 0, 50, 0.5),)),




            Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
              arcChooser,
            ],),




            Positioned(left: 0, child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: <Widget>[

              AnimatedContainer( duration: Duration(milliseconds: btnAnimationDuration),
              width: activatedBtnNumber>0?animatedBtnOpenSize:animatedBtnClosedSize,
              child: ButtonTheme(height: buttonHeight,
                child: RaisedButton(onPressed: () {
                  setState(() {
                    if(pollenBtnText.length!=0) {
                      activatedBtnNumber = 0;
                      _arcChooserkey.currentState.setData(activatedBtnNumber,0,0);
                    }
                  });
                },
                    color: Colors.greenAccent[100],
                    child: Text(pollenBtnText, textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0.0))),)
              ),


              AnimatedContainer( duration: Duration(milliseconds: btnAnimationDuration),
                  width: activatedBtnNumber>1?animatedBtnOpenSize:animatedBtnClosedSize,
                  child: ButtonTheme(height: buttonHeight,
                    child: RaisedButton(onPressed: () {
                      setState(() {
                        if(alimentsBtnText.length!=0) {
                          activatedBtnNumber = 1;
                          _arcChooserkey.currentState.setData(activatedBtnNumber,1,0);
                        }
                      });
                    },
                        color: Colors.amberAccent[100],
                        child: Text(alimentsBtnText, textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0.0))),)
              ),


            ],),),





            Positioned(right: 0, child: Column(crossAxisAlignment: CrossAxisAlignment.end,children: <Widget>[

              AnimatedContainer( duration: Duration(milliseconds: btnAnimationDuration),
                  width: activatedBtnNumber>2?animatedBtnOpenSize:animatedBtnClosedSize,
                  child: ButtonTheme(height: buttonHeight,
                    child: RaisedButton(onPressed: () {
                      setState(() {
                        if(mFamilyBtnText.length!=0) {
                          activatedBtnNumber = 2;
                          _arcChooserkey.currentState.setData(activatedBtnNumber,pollenId,alimentId);
                          currentBgImage = molecularFamilyImage;
                        }
                      });
                    },
                        color: Colors.cyan[100],
                        child: Text(mFamilyBtnText, textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0.0))),)
              ),



              AnimatedContainer( duration: Duration(milliseconds: btnAnimationDuration),
                  width: activatedBtnNumber>3?animatedBtnOpenSize:animatedBtnClosedSize,
                  child: ButtonTheme(height: buttonHeight,
                    child: RaisedButton(onPressed: () {
                      setState(() {
                        if(mAllergeneBtnText.length!=0) {
                          activatedBtnNumber = 3;
                          _arcChooserkey.currentState.setData(activatedBtnNumber,mFamilyId,0);
                          currentBgImage = molecularAllergeneImage;
                        }
                      });
                    },
                        color: Colors.deepOrangeAccent[100],
                        child: Text(mAllergeneBtnText, textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0.0))),)
              ),


              IgnorePointer(child:
                Container( alignment: Alignment.topCenter, padding: EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(children: <Widget>[
                    Text(choiceTitle,textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white,fontSize: 30)),

                    Text(choiceSubTitle,textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[300],fontSize: 16)),
                  ],)
                ),
              )

            ],),),


          ],),)
        ],
      ));





  }


  onAllergensChangeEvent() {
    _arcChooserkey.currentState.getData();
  }
}
