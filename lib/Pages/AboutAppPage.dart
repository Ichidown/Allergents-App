
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class AboutAppPage extends StatefulWidget {
  @override
  _AboutAppPageState createState() => _AboutAppPageState();
}

class _AboutAppPageState extends State<AboutAppPage> {
  static const String routeName = '/cms';

  TextStyle textStyle = new TextStyle(fontSize: 16, color: Colors.grey);
  TextStyle mainTextStyle = new TextStyle(fontSize: 16, color: Colors.grey[800], fontWeight: FontWeight.bold);
  TextStyle linkStyle = new TextStyle(fontSize: 12, color: Colors.lightBlue);


  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.grey[200],
        appBar: PreferredSize( preferredSize: Size.fromHeight(40.0), child: AppBar(title: Text('About this App'),centerTitle: true,),),
        body:

        //Wrap(children: <Widget>[


ListView(scrollDirection: Axis.horizontal,shrinkWrap: true,children: <Widget>[



    Card(elevation: 5,margin: EdgeInsets.all(10),child: Column(children: <Widget>[
        Padding(padding: EdgeInsets.all(10),child: Text('Developped By :', style: textStyle,),),
        Flexible(child: Image(fit: BoxFit.cover,image: AssetImage('assets/images/Developer.jpg'))),
        Padding(padding: EdgeInsets.all(10),child: Column(children: <Widget>[
        Text('Mehemmai Mohammed Ridha', style: mainTextStyle,),
        SizedBox(height: 20),
        GestureDetector(child: Row(children: <Widget>[Icon(Icons.public,color: Colors.lightBlue,), Text('  Ichidown.github.io', style: linkStyle)],), onTap: (){_launchURL('https://ichidown.github.io/');},),
        GestureDetector(child: Row(children: <Widget>[Icon(Icons.mail,color: Colors.lightBlue,), Text('  MedRidhaMeh@Gmail.com', style: linkStyle)],), onTap: (){_launchURL('mailto:MedRidhaMeh@Gmail.com');},),
        GestureDetector(child: Row(children: <Widget>[Icon(Icons.phone,color: Colors.lightBlue,), Text('  0550772849', style: linkStyle)],), onTap: (){_launchURL('tel:0550772849');},),
        ],),),
    ],)
    ),


  Card(elevation: 5,margin: EdgeInsets.all(10),child: Column(children: <Widget>[
    Padding(padding: EdgeInsets.all(10),child: Text('In Collaboration With :', style: textStyle,),),
    Flexible(child: Image(fit: BoxFit.cover,image: AssetImage('assets/images/Owner.jpg'))),
    Padding(padding: EdgeInsets.all(10),child: Column(children: <Widget>[
      Text('Djemai Belaid', style: mainTextStyle,),
      SizedBox(height: 20),
      GestureDetector(child: Row(children: <Widget>[Icon(Icons.public,color: Colors.lightBlue,), Text('  some Web Link', style: linkStyle)],), onTap: (){_launchURL('some Web Link');},),
      GestureDetector(child: Row(children: <Widget>[Icon(Icons.mail,color: Colors.lightBlue,), Text('  belaiddjoumouai@hotmail.fr', style: linkStyle)],), onTap: (){_launchURL('mailto:belaiddjoumouai@hotmail.fr');},),
      GestureDetector(child: Row(children: <Widget>[Icon(Icons.phone,color: Colors.lightBlue,), Text('  0661374237', style: linkStyle)],), onTap: (){_launchURL('tel:0661374237');},),
    ],),),
  ],)
  ),




],)



/**
          Card(elevation: 5,margin: EdgeInsets.all(10),child: Center(child:Wrap(direction: Axis.vertical ,children: <Widget>[

            SizedBox(width: 260, height: 290,child:
            Image(fit: BoxFit.cover,image: AssetImage('assets/images/ProfilePic-Cropped.png')),
            ),

            Text('Developped By :', style: textStyle,),
            Text('Mehemmai Mohammed Ridha', style: textStyle,),

            GestureDetector(child: Text('Ichidown.github.io', style: linkStyle), onTap: (){_launchURL('https://ichidown.github.io/');},),
            GestureDetector(child: Text('MedRidhaMeh@Gmail.com', style: linkStyle), onTap: (){_launchURL('mailto:MedRidhaMeh@Gmail.com');},),
            GestureDetector(child: Text('0550772849', style: linkStyle), onTap: (){_launchURL('tel:0550772849');},),

            Text('In Collaboration with : ...', style: textStyle,),





          ],)
          )),

*/





        //],)











    );
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


}