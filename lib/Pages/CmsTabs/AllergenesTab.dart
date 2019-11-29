import 'package:allergensapp/Beings/Allergene.dart';
import 'package:allergensapp/Pages/Dialogs/ColorPickerDialog.dart';
import 'package:allergensapp/Pages/Dialogs/DeleteDialog.dart';
import 'package:allergensapp/Pages/Dialogs/AllergeneDialog.dart';
import 'package:allergensapp/Tools/UiTools.dart';
import 'package:allergensapp/Tools/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../CmsPage.dart';

class AllergenesTab extends StatefulWidget {
  //var setTabTitle;
  //GlobalKey<_CmsPageState> cmsKey;


  //AllergenesTab({this.setTabTitle});

  @override
  _AllergenesTabState createState() => _AllergenesTabState();

}


class _AllergenesTabState extends State<AllergenesTab> {

  //var tabTitle;
  //var setTabTitle;
  //GlobalKey<_CmsPageState> cmsKey;
  //_AllergenesTabState(this.setTabTitle);

  List<String> allergeneTypeList = ['Pollens', 'Aliments'];
  Future<List<Allergene>> allergeneList;






  //CmsPage _cmsPage;
  //_AllergenesTabState(this._cmsPage);

  //static List<String> _typeList = ['Pollens', 'Aliments'];
  //Future<List<Allergene>> allergeneList;

  final dbHelper = DatabaseHelper.instance;
  final String deleateMsg = 'Are you sure you want to deleate this allergene ?';









  @override
  Widget build(BuildContext context) {
    //tabTitle();

    //print('Allergene Tab');
    //setTabTitle('Allergene Tab');

    return Stack(
      children: <Widget>[
        SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 80),
            child: FutureBuilder<List<Allergene>>(
                future: refreshAllergeneList(),
                // initialData: allergeneList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        //key: _allergeneListKey,
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
                                    return AllergeneDialog(snapshot.data[i]);
                                  }).then((onValue) {newAllergenes(onValue);});
                            },
                            onLongPress: () {
                              showDialog(context: context, builder: (context) {
                                    return DeleteDialog(deleateMsg);
                                  }).then((onValue) {
                                    if (onValue) deleteAllergenes(snapshot.data[i].id);
                                  });
                            },
                            leading: GestureDetector(onTap: (){
                              showDialog(context: context, builder: (context) {
                                return ColorPickerDialog();
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
                            subtitle: Text(allergeneTypeList[snapshot.data[i].allergeneType]),
                            trailing: // FlatButton(onPressed: (){print("Deleate");},child: Text('X'))

                                GestureDetector(
                              onTap: () {
                                showDialog(context: context, builder: (context) {
                                  return DeleteDialog(deleateMsg);
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
                        return AllergeneDialog(null);//false);
                      }).then((onValue) {newAllergenes(onValue);});
                },
                child: Icon(Icons.add),
              ),
            )),
      ],
    );
  }











  Future<List<Allergene>> refreshAllergeneList() async {
    setState(() {allergeneList = dbHelper.getAllergenes();});
    return allergeneList;
  }

  void deleteAllergenes(int index) async {
    bool success = await dbHelper.deleteAllergene(index) > 0; // if deleted something
    if (success) refreshAllergeneList();

    UiTools.newSnackBar(
        success?'Allergene deleted successfully':'Error while deleting the allergene',
        success?Colors.green:Colors.redAccent, 1, context);
  }


  void newAllergenes(Allergene returnedValue) async {
    if (returnedValue != null){
      bool isEdit = returnedValue.id != 0;

      int id = isEdit ? await dbHelper.updateAllergene(returnedValue.toJson()):
                        await dbHelper.insertAllergene(returnedValue.toJsonNoId());

      bool success = id>0;
      if(success) refreshAllergeneList();

      UiTools.newSnackBar(
          success?(isEdit?'Allergene edited successfully':'Allergene created successfully'):
                  (isEdit?'Error while editing the allergene':'Error while creating the allergene'),
          success?Colors.green:Colors.redAccent, 1, context);
    }
  }

  void updateAllergeneColor(Allergene tempValue, String color){ /** This should be optimised **/
    tempValue.color = color;
    dbHelper.updateAllergene(tempValue.toJson());
    refreshAllergeneList();
  }




}