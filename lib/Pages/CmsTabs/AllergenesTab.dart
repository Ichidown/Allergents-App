import 'package:allergensapp/Beings/Allergene.dart';
import 'package:allergensapp/Pages/Dialogs/AllergeneColorPickerDialog.dart';
import 'package:allergensapp/Pages/Dialogs/DeleteAllergeneDialog.dart';
import 'package:allergensapp/Pages/Dialogs/NewAllergeneDialog.dart';
import 'package:allergensapp/Tools/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AllergenesTab extends StatefulWidget {
  @override
  _AllergenesTabState createState() => _AllergenesTabState();
}

class _AllergenesTabState extends State<AllergenesTab> {
  static List<String> _typeList = ['Pollens', 'Aliments'];
  static const String routeName = '/cms';
  final dbHelper = DatabaseHelper.instance;
  Future<List<Allergene>> allergeneList;
  final _allergeneListKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // allergeneList = dbHelper.getAllergenes();

    return Stack(
      children: <Widget>[
        SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 80),
            child: FutureBuilder<List<Allergene>>(
                future: dbHelper.getAllergenes(),
                // initialData: allergeneList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        key: _allergeneListKey,
                        itemCount: snapshot.data.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, i) {
                          return Card(
                              child: ListTile(
                            dense: true,
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return NewAllergeneDialog(snapshot.data[i]);
                                  }).then((onValue) {newAllergenes(onValue);});
                            },
                            onLongPress: () {
                              showDialog(context: context, builder: (context) {
                                    return DeleteAllergeneDialog();
                                  }).then((onValue) {
                                    if (onValue) deleteAllergenes(snapshot.data[i].id);
                                  });
                            },
                            leading: GestureDetector(onTap: (){
                              showDialog(context: context, builder: (context) {
                                return AllergeneColorPickerDialog();
                              }).then((onValue) {
                                if (onValue != null){
                                  print(onValue);
                                  updateAllergeneColor(snapshot.data[i] ,onValue);
                                }
                              });
                            },
                                child: Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color(int.parse(snapshot.data[i].color)),
                                      shape: BoxShape.circle,
                                    ),
                                    width: 50,
                                  ),
                                  Text(snapshot.data[i].id.toString()),
                                ])
                                ),
                            title: Text(snapshot.data[i].name),
                            subtitle:
                                Text(_typeList[snapshot.data[i].allergeneType]),
                            trailing: // FlatButton(onPressed: (){print("Deleate");},child: Text('X'))

                                GestureDetector(
                              onTap: () {
                                showDialog(context: context, builder: (context) {
                                  return DeleteAllergeneDialog();
                                }).then((onValue) {
                                  if (onValue) deleteAllergenes(snapshot.data[i].id);
                                });
                              },
                              child: Container(
                                child: Icon(Icons.clear),
                              ),
                            ),
                          ));
                        });
                  } else {
                    return ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                    );
                    //return null;
                  }
                })),
        Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.all(10),
              child: FloatingActionButton(
                tooltip: 'New Allergene',
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return NewAllergeneDialog(null);//false);
                      }).then((onValue) {newAllergenes(onValue);});
                }
                ,
                child: Icon(Icons.add),
              ),
            )),
      ],
    );
  }

  Future<List<Allergene>> refreshAllergeneList() async {
    setState(() {
      allergeneList = dbHelper.getAllergenes();
    });
    return allergeneList;
  }

  void deleteAllergenes(int index) async {
    bool success = await dbHelper.deleteAllergene(index) > 0; // if deleted something
    if (success) {
      refreshAllergeneList();

      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Allergene deleted successfully'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ));
    } // failed
    else
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Error while deleting allergene'),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 1),
      ));
  }


  void newAllergenes(String onValue) async {
    if (onValue != null) {
      if (onValue == '1') // success
          {
        refreshAllergeneList();
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Allergene created successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ));
      } else if (onValue == '2') // failed
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Error while creating allergene'),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 1),
        ));
    }
  }

  void updateAllergeneColor(Allergene tempAllergene, String color){ /** This should be optimised **/
    tempAllergene.color = color;
    print(color);
    dbHelper.updateAllergene(tempAllergene.toJson());
    refreshAllergeneList();
  }




}