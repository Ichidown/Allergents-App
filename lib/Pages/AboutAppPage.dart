
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class AboutAppPage extends StatelessWidget {

  TextStyle textStyle = new TextStyle(fontSize: 16, color: Colors.grey);
  TextStyle mainTextStyle = new TextStyle(fontSize: 16, color: Colors.grey[800], fontWeight: FontWeight.bold);
  TextStyle linkStyle = new TextStyle(fontSize: 12, color: Colors.lightBlue);

  final String titleBarText = "A propos de l'application";
  final String functionText1 = 'Développé par :';
  final String functionText2 = 'En collaboration avec :';

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.grey[200],
        appBar: PreferredSize( preferredSize: Size.fromHeight(40.0), child: AppBar(title: Text(titleBarText),centerTitle: true,),),
        body:

        ListView(scrollDirection: Axis.horizontal,shrinkWrap: true,children: <Widget>[



          Card(elevation: 5,margin: EdgeInsets.all(20),child: Column(children: <Widget>[
            Padding(padding: EdgeInsets.all(10),child: Text(functionText1, style: textStyle,),),
            Flexible(child: Image(fit: BoxFit.cover,image: AssetImage('assets/images/Developer.jpg'))),
            Padding(padding: EdgeInsets.all(10),child: Column(children: <Widget>[
              //Text('Mehemmai Mohammed Ridha', style: mainTextStyle,),
              Container(alignment: Alignment.center,width: 230, child: Text('Mehemmai Mohammed Ridha', style: mainTextStyle,),),
              SizedBox(height: 20),
              Column(crossAxisAlignment: CrossAxisAlignment.start,children: <Widget>[
                GestureDetector(child: Row(children: <Widget>[Icon(Icons.mail,color: Colors.lightBlue,), Text('  MedRidhaMeh@Gmail.com', style: linkStyle)],), onTap: (){_launchURL('mailto:MedRidhaMeh@Gmail.com');},),
                GestureDetector(child: Row(children: <Widget>[Icon(Icons.public,color: Colors.lightBlue,), Text('  Ichidown.github.io', style: linkStyle)],), onTap: (){_launchURL('https://ichidown.github.io/');},),
                GestureDetector(child: Row(children: <Widget>[Icon(Icons.phone,color: Colors.lightBlue,), Text('  0550772849', style: linkStyle)],), onTap: (){_launchURL('tel:0550772849');},),
              ],),
            ],),),
          ],)
          ),


          Card(elevation: 5,margin: EdgeInsets.all(20),child: Column(children: <Widget>[
            Padding(padding: EdgeInsets.all(10),child: Text(functionText2, style: textStyle,),),
            Flexible(child: Image(fit: BoxFit.cover,image: AssetImage('assets/images/Owner.jpg'))),
            Padding(padding: EdgeInsets.all(10),child: Column(children: <Widget>[
              Container(alignment: Alignment.center,width: 230, child: Text('Djemai Belaid', style: mainTextStyle,),),
              SizedBox(height: 20),
              Column(crossAxisAlignment: CrossAxisAlignment.start,children: <Widget>[
                GestureDetector(child: Row(children: <Widget>[Icon(Icons.mail,color: Colors.lightBlue,), Text('  belaiddjoumouai@hotmail.fr', style: linkStyle)],), onTap: (){_launchURL('mailto:belaiddjoumouai@hotmail.fr');},),
                GestureDetector(child: Row(children: <Widget>[Icon(Icons.phone,color: Colors.lightBlue,), Text('  0661374237', style: linkStyle)],), onTap: (){_launchURL('tel:0661374237');},),
              ]),
              SizedBox(height: 20),
            ],),),
          ],)
          ),


        ],)

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
