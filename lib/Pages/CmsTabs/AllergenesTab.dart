import 'package:allergensapp/Beings/Allergene.dart';
import 'package:allergensapp/Pages/Dialogs/NewAllergeneDialog.dart';
import 'package:allergensapp/Tools/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


class AllergenesTab extends StatelessWidget {

  static const String routeName = '/cms';
  final dbHelper = DatabaseHelper.instance;
  List<Allergene> allergeneList;
  final _allergeneListKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {

    // allergeneList = dbHelper.getAllergenes();

    return Stack(children: <Widget>[
      SingleChildScrollView( padding: EdgeInsets.fromLTRB(0, 20, 0, 80),
          child:FutureBuilder<List<Allergene>>(
              key: _allergeneListKey,
              future: dbHelper.getAllergenes(),
              // initialData: allergeneList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, i) {
                        return Card(child: ListTile(dense: true,
                          onTap: () {print('Edit');},
                          onLongPress: () {print('Deleate');},
                          leading: Stack(alignment: Alignment.center, children: <Widget>[
                            Container(decoration: BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle,), width: 50,),
                            Text(snapshot.data[i].id.toString()),
                          ]),
                          title: Text(snapshot.data[i].name),
                          subtitle: Text(snapshot.data[i].allergeneType.toString()),
                          trailing: // FlatButton(onPressed: (){print("Deleate");},child: Text('X'))

                          GestureDetector(onTap: () { print("Deleate");},child:
                          Container(child: Icon(Icons.clear),),),

                        ));
                      });
                } else { return ListView(shrinkWrap: true, physics: NeverScrollableScrollPhysics(),
                );
                  //return null;
                }
              }
          )
      ),


      Align(alignment: Alignment.bottomRight,
          child:
          Container( margin: EdgeInsets.all(10),
            child: FloatingActionButton(tooltip: 'New Allergene',
              onPressed: () {
                // print('Btn clicked');

                showDialog(context : context, builder: (context) {return NewAllergeneDialog();}).then((onValue){
                  // _query();
                  if (onValue!=null){
                    if (onValue == '1') // success
                      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Allergene created successfully'),backgroundColor: Colors.green,duration:Duration(seconds: 1),));
                    else if(onValue == '2') // failed
                      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Error while creating allergene'),backgroundColor: Colors.redAccent,duration:Duration(seconds: 1),));
                  }
                });
              },
              child: Icon(Icons.add),
            ),
          )
      )
    ],);
  }




  /*void _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));

    //setState(() {
      // allergeneList = dbHelper.getAllergenes();
      // _allergeneListKey.currentState.build(context);
      // allergeneList = [];
    //});
  }*/






/*Future<String> createAlertDialog(BuildContext context){
    _query();

    return ;
  }*/
}






























