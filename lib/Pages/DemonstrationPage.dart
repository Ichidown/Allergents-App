
import 'package:flutter/material.dart';
import '../arcChooser.dart';
import 'CmsPage.dart';


class DemonstrationPage extends StatefulWidget {
  static const String routeName = '/demonstration';

  @override
  _DemonstrationPageState createState() => _DemonstrationPageState();
}

class _DemonstrationPageState extends State<DemonstrationPage> {
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
          drawer: Drawer(child: ListView(padding: EdgeInsets.zero ,children: <Widget>[
            DrawerHeader(decoration: BoxDecoration(color: Colors.blue,),
              child: Text('Database Management'), ),

            new ListTile(title: Text('Allergenes'),onTap: () {
              Navigator.of(context).pop();}),

            new ListTile(title: Text('CMS'),onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => CmsPage()));}),

          ],),),

          appBar: PreferredSize( preferredSize: Size.fromHeight(40.0),
              child : AppBar(
                title: Text('Allergens App'),
                centerTitle: true,
              )),

          body: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[

          ButtonTheme( height: 20.0,
            child: RaisedButton(onPressed: (){print("Pollens");},color: Colors.amber[100] ,
                child: Text('Pollens', textAlign: TextAlign.center,),materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0.0))),),

          ButtonTheme( height: 20.0,
            child: RaisedButton(onPressed: (){print("Aliments");},color: Colors.lightGreen[100] ,
                child: Text('Aliments', textAlign: TextAlign.center,),materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0.0))),),

          ButtonTheme( height: 20.0,
            child: RaisedButton(onPressed: (){print("familles moleculaires");},color: Colors.cyan[100] ,
                child: Text('familles moleculaires', textAlign: TextAlign.center,),materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0.0))),),

          ButtonTheme( height: 20.0,
            child: RaisedButton(onPressed: (){print("alergenes moleculaires");},color: Colors.deepOrangeAccent[100] ,
                child: Text('alergenes moleculaires', textAlign: TextAlign.center,),materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0.0))),),


          Expanded(child:
          Stack(children: <Widget>[
            //ArcChooser()
            /*FittedBox(
                child: Image(image: AssetImage('assets/images/Aliments.jpg'),),
                fit: BoxFit.fill,
              ),
*/
            Container(
              decoration: BoxDecoration(
                image: DecorationImage( image: AssetImage("assets/images/Aliments.jpg"), fit: BoxFit.cover,),
              ),),
            Container(
              color: Color.fromRGBO(0, 0, 50, 0.5),
            ),


            Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
              ArcChooser(),
            ],)


          ],),)



          //Row(mainAxisAlignment: MainAxisAlignment.end,children: <Widget>[
          //Expanded(child: Container(),),
          //Container(child: ArcChooser(), height: 300,)
          //],)




        ],
      ));

  }
}