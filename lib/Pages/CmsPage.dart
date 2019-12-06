
import '../Pages/CmsTabs/ReactionToMolecularAllergeneTab.dart';
import '../Pages/CmsTabs/ReactionsTab.dart';
import 'package:flutter/material.dart';
import 'CmsTabs/AllergenesTab.dart';
import 'CmsTabs/MolecularAllergenesTab.dart';
import 'CmsTabs/MolecularFamiliesTab.dart';
import 'CmsTabs/MolecularFamilyToAllergeneTab.dart';





class CmsPage extends StatefulWidget {
  var onAllergensChangeEvent;

  CmsPage(this.onAllergensChangeEvent): super();

  @override
  _CmsPageState createState() => _CmsPageState(onAllergensChangeEvent);
}

class _CmsPageState extends State<CmsPage> {
  var onAllergensChangeEvent;
  static const String routeName = '/cms';
  TextStyle tabTextStyle = new TextStyle(fontSize: 9);

  List<Widget> tabList;
  int tabItemNumber;
  String title = "Gestion du contenu";

  _CmsPageState(this.onAllergensChangeEvent);





  @override
  void initState() {

    tabList =  [
      AllergenesTab(onAllergensChangeEvent),
      MolecularFamiliesTab(),
      MolecularAllergenesTab(),
      ReactionsTab(),
      MolecularFamilyToAllergeneTab(),
      ReactionToMolecularAllergeneTab(),
    ];
    tabItemNumber = tabList.length;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabItemNumber,
      child: Scaffold( backgroundColor: Colors.grey[200],
        appBar: PreferredSize( preferredSize: Size.fromHeight(90.0),
          child : AppBar(
            bottom: TabBar(labelPadding: EdgeInsets.all(2),
              tabs: [
                Tab(icon: Icon(Icons.local_florist)),// child: Text('Allergenes',style: tabTextStyle,)),
                Tab(icon: Icon(Icons.category)),//,child: Text('Molecular families',style: tabTextStyle,)),
                Tab(icon: Icon(Icons.bubble_chart)),//child: Text('Molecular allergens',style: tabTextStyle,)),
                Tab(icon: Icon(Icons.airline_seat_flat_angled)),//child: Text('Adapted treatment',style: tabTextStyle,)),
                Tab(icon: Icon(Icons.spa)),//child: Text('Molecular families / Allergenes',style: tabTextStyle,)),
                Tab(icon: Icon(Icons.streetview)),//child: Text('Molecular allergene / Reaction',style: tabTextStyle,)),
              ],
            ),
            title: Text(title),
            centerTitle: true,
          ),
        ),

        body: TabBarView(children: tabList,
        ),
      ),
    );
  }



  void updateTitle(String newText){
    setState(() {title = newText;});
  }



}