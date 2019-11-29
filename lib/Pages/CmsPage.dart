
import '../Pages/CmsTabs/ReactionToMolecularAllergeneTab.dart';
import '../Pages/CmsTabs/ReactionsTab.dart';
import 'package:flutter/material.dart';
import 'CmsTabs/AllergenesTab.dart';
import 'CmsTabs/MolecularAllergenesTab.dart';
import 'CmsTabs/MolecularFamiliesTab.dart';
import 'CmsTabs/MolecularFamilyToAllergeneTab.dart';





class CmsPage extends StatefulWidget {
  @override
  _CmsPageState createState() => _CmsPageState();
}

class _CmsPageState extends State<CmsPage> {
  static const String routeName = '/cms';
  TextStyle tabTextStyle = new TextStyle(fontSize: 9);

  List<Widget> tablist;
  int tabItemNumber;
  String title = 'Content Manager System';

  _CmsPageState();//AllergenesTab().getTabTitle();

  @override
  void initState() {

    tablist =  [
      AllergenesTab(),
      MolecularFamiliesTab(),
      MolecularAllergenesTab(),
      ReactionsTab(),
      MolecularFamilyToAllergeneTab(),
      ReactionToMolecularAllergeneTab(),
    ];
    tabItemNumber = tablist.length;
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
                Tab(child: Text('Allergenes',style: tabTextStyle,)),
                Tab(child: Text('Molecular families',style: tabTextStyle,)),
                Tab(child: Text('Molecular allergens',style: tabTextStyle,)),
                Tab(child: Text('Adapted treatment',style: tabTextStyle,)),
                Tab(child: Text('Molecular families / Allergenes',style: tabTextStyle,)),
                Tab(child: Text('Molecular allergene / Reaction',style: tabTextStyle,)),
              ],
            ),
            title: Text(title),
            centerTitle: true,
          ),
        ),

        body: TabBarView(children: tablist,
        ),
      ),
    );
  }



  void updateTitle(String newText){
    setState(() {title = newText;});
  }



}