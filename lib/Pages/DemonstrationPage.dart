
import 'package:flutter/material.dart';
import '../arcChooser.dart';
import 'CmsPage.dart';


class DemonstrationPage extends StatefulWidget {
  static const String routeName = '/demonstration';

  @override
  _DemonstrationPageState createState() => _DemonstrationPageState();
}

class _DemonstrationPageState extends State<DemonstrationPage> with TickerProviderStateMixin {

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

  final String appTitle = 'Allergens App';
  final String drawerTabTitle = 'Database Management';
  final String tab1Text = 'Allergenes';
  final String tab2Text = 'CMS';

  String choiceTitle = 'Allergene Super Long Name';

  String pollenBtnText = '';
  String alimentsBtnText = '';
  String mFamilyBtnText = '';
  String mAllergeneBtnText = '';



  List<Image> imageList = [
    Image.asset('assets/images/india3_19.jpg'),
    Image.asset('assets/images/Aliments.jpg'),
    Image.asset('assets/images/1 cuTSPlTq0a_327iTPJyD-Q.png'),

  ];
  PageController imageViewController = PageController(initialPage: 1);



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    buttonsAnimationCon = AnimationController(vsync: this,duration: Duration(microseconds: 300));
    btnAnimation = Tween(begin: 1.0, end: 0.5).animate(CurvedAnimation(parent: buttonsAnimationCon,curve: Curves.easeInOut));


  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
          drawer: Drawer(child: ListView(padding: EdgeInsets.zero ,children: <Widget>[
            DrawerHeader(decoration: BoxDecoration(color: Colors.blue,),
              child: Text(drawerTabTitle), ),

            new ListTile(title: Text(tab1Text),onTap: () {
              Navigator.of(context).pop();}),

            new ListTile(title: Text(tab2Text),onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => CmsPage()));}),

          ],),),

          appBar: PreferredSize( preferredSize: Size.fromHeight(40.0),
              child : AppBar(
                title: Text(appTitle),
                centerTitle: true,
              )),

          body:
          Column(//crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[



          Expanded(child:
          Stack(children: <Widget>[

            Container(
              decoration: BoxDecoration(
                image: DecorationImage( image: AssetImage("assets/images/i89767-.jpg"), fit: BoxFit.cover,),
              ),
            //child: imageList[0],
            ),









          //Container(child:FittedBox(child: imageList[0],fit: BoxFit.cover)),

            /*PageView.builder(controller: imageViewController,
                itemCount: imageList.length,
                itemBuilder: (context,position){
              return imageSlider(position);
            }),*/

          //Container( child : FittedBox(fit: BoxFit.cover, child:
            /*Container(
              child: CarouselSlider(viewportFraction: 1.0,
                items: imageList.map((i) {
                  return Builder(builder: (BuildContext context) { return //i;
                    FittedBox(fit: BoxFit.contain, child:i);
                  },);
                }).toList(),
              ),
            ),*/

            //),),


















            IgnorePointer( child: Container(
              color: Color.fromRGBO(0, 0, 50, 0.5),
            )),






            //IgnorePointer( child :
            Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
              ArcChooser(onTextSelect: (String mainText) {
                setState(() {
                  choiceTitle = mainText;
                });
              }),
            ],),
            //),


            Positioned(left: 0, child:
            Column(crossAxisAlignment: CrossAxisAlignment.start,children: <Widget>[

              AnimatedContainer( duration: Duration(milliseconds: btnAnimationDuration),
              width: allergeneBtnOpen?animatedBtnOpenSize:animatedBtnClosedSize,
              child: ButtonTheme(height: buttonHeight,
                child: RaisedButton(onPressed: () {
                  print(pollenBtnText);
                  setState(() {
                    allergeneBtnOpen=!allergeneBtnOpen;
                  });
                  //clicked?buttonsAnimationCon.forward():buttonsAnimationCon.reverse();
                },
                    color: Colors.greenAccent[100],
                    child: Text(pollenBtnText, textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0.0))),)
              ),







              AnimatedContainer( duration: Duration(milliseconds: btnAnimationDuration),
                  width: pollenBtnOpen?animatedBtnOpenSize:animatedBtnClosedSize,
                  child: ButtonTheme(height: buttonHeight,
                    child: RaisedButton(onPressed: () {
                      print(alimentsBtnText);
                      setState(() {
                        pollenBtnOpen=!pollenBtnOpen;
                      });
                      //clicked?buttonsAnimationCon.forward():buttonsAnimationCon.reverse();
                    },
                        color: Colors.amberAccent[100],
                        child: Text(alimentsBtnText, textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0.0))),)
              ),



            ],),
            ),





            Positioned(right: 0, child:
            Column(crossAxisAlignment: CrossAxisAlignment.end,children: <Widget>[



              AnimatedContainer( duration: Duration(milliseconds: btnAnimationDuration),
                  width: mFamilyBtnOpen?animatedBtnOpenSize:animatedBtnClosedSize,
                  child: ButtonTheme(height: buttonHeight,
                    child: RaisedButton(onPressed: () {
                      print(mFamilyBtnText);
                      setState(() {
                        mFamilyBtnOpen=!mFamilyBtnOpen;
                      });
                      //clicked?buttonsAnimationCon.forward():buttonsAnimationCon.reverse();
                    },
                        color: Colors.cyan[100],
                        child: Text(mFamilyBtnText, textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0.0))),)
              ),





              AnimatedContainer( duration: Duration(milliseconds: btnAnimationDuration),
                  width: mAllergeneBtnOpen?animatedBtnOpenSize:animatedBtnClosedSize,
                  child: ButtonTheme(height: buttonHeight,
                    child: RaisedButton(onPressed: () {
                      print(mAllergeneBtnText);
                      setState(() {
                        mAllergeneBtnOpen=!mAllergeneBtnOpen;
                      });
                      //clicked?buttonsAnimationCon.forward():buttonsAnimationCon.reverse();
                    },
                        color: Colors.deepOrangeAccent[100],
                        child: Text(mAllergeneBtnText, textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0.0))),)
              ),




/*

              ButtonTheme(height: 40.0,
                child: RaisedButton(onPressed: () {print("familles moleculaires");},
                    color: Colors.cyan[100],
                    child: Text('familles moleculaires',
                      textAlign: TextAlign.center,),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0.0))),),


              ButtonTheme(height: 40.0,
                child: RaisedButton(onPressed: () {print("alergenes moleculaires");},
                    color: Colors.deepOrangeAccent[100],
                    child: Text('alergenes moleculaires',
                      textAlign: TextAlign.center,),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0.0))),),
*/

            //FittedBox(child:


              IgnorePointer(child:
                Container( alignment: Alignment.topCenter, padding: EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child:
                  Text(choiceTitle,textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white,fontSize: 30)),
                ),
              )


            //)




            ],),
            ),






















          ],),)



          //Row(mainAxisAlignment: MainAxisAlignment.end,children: <Widget>[
          //Expanded(child: Container(),),
          //Container(child: ArcChooser(), height: 300,)
          //],)




        ],
      ));










  }


  void updateTitle(String newText){
    setState(() {
      choiceTitle = newText;
    });
  }

  /*AnimatedBuilder imageSlider(int index){
    return AnimatedBuilder(
      animation: imageViewController,
      builder: (context,widget){

        /*double value = 1;
        if(imageViewController.position.haveDimensions){
          value = imageViewController.page - index;
          value = (1-(value.abs()*0.3)).clamp(0.0,1.0);
        }*/

        return Container(
          //margin: EdgeInsets.all(20/Curves.easeInQuad.transform(value)),
          child: FittedBox(child: widget,fit: BoxFit.cover),);
      },
      child:imageList[index],
    );
  }*/




}
