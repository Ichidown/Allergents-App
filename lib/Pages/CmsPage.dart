
import 'package:allergensapp/Beings/Allergene.dart';
import 'package:allergensapp/Beings/MolecularAllergene.dart';
import 'package:allergensapp/Beings/MolecularFamily.dart';
import 'package:allergensapp/Beings/Reaction.dart';
import 'package:allergensapp/Pages/CmsTabs/ReactionsTab.dart';
import 'package:flutter/material.dart';
import 'CmsTabs/AllergenesTab.dart';
import 'CmsTabs/MolecularAllergenesTab.dart';
import 'CmsTabs/MolecularFamiliesTab.dart';





class CmsPage extends StatefulWidget {
  @override
  _CmsPageState createState() => _CmsPageState();
}

class _CmsPageState extends State<CmsPage> {
  static const String routeName = '/cms';








  List<Widget> tablist;
  int tabItemNumber;
  String title = 'Content Manager System';//AllergenesTab().getTabTitle();

  @override
  void initState() {

    tablist =  [
      AllergenesTab(),
      MolecularFamiliesTab(),
      MolecularAllergenesTab(),
      ReactionsTab(),
      Text('1'),
      Text('1'),
    ];
    tabItemNumber = tablist.length;

  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabItemNumber,
      child: Scaffold( backgroundColor: Colors.grey[200],
        appBar: PreferredSize( preferredSize: Size.fromHeight(90.0),
          child : AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.directions_car)),//,text: 'Allergenes',),
                Tab(icon: Icon(Icons.directions_transit)),//,text: 'Molecular families'),
                Tab(icon: Icon(Icons.directions_bike)),//,text: 'Molecular allergens'),
                Tab(icon: Icon(Icons.airline_seat_flat_angled)),//,text: 'Adapted treatment'),
                Tab(icon: Icon(Icons.extension)),//,text: 'Molecular families X Allergenes'),
                Tab(icon: Icon(Icons.ac_unit)),//,text: 'Molecular allergene X reaction'),
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





}