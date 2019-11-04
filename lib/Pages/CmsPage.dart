
import 'package:flutter/material.dart';
import 'CmsTabs/AllergenesTab.dart';


class CmsPage extends StatelessWidget {
  static const String routeName = '/cms';

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold( backgroundColor: Colors.grey[200],
        appBar: PreferredSize( preferredSize: Size.fromHeight(110.0),
          child : AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.directions_car),text: 'Allergenes',),
                Tab(icon: Icon(Icons.directions_transit),text: 'Molecular families'),
                Tab(icon: Icon(Icons.directions_bike),text: 'Molecular allergens'),
                Tab(icon: Icon(Icons.directions_bike),text: 'Adapted treatment'),
              ],
            ),
            title: Text('Tabs Demo'),
            centerTitle: true,
          ),
        ),

        body: TabBarView(
          children: [
            AllergenesTab(),
            Icon(Icons.directions_transit),
            Icon(Icons.directions_bike),
            Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }
}