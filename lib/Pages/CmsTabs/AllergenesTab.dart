import 'package:allergensapp/Widgets/TabTitleBar.dart';
import '../../Beings/Allergen.dart';
import '../../Pages/Dialogs/ColorPickerDialog.dart';
import '../../Pages/Dialogs/DeleteDialog.dart';
import '../../Pages/Dialogs/AllergeneDialog.dart';
import '../../Tools/UiTools.dart';
import '../../Tools/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


class AllergenesTab extends StatefulWidget {
  var onAllergensChangeEvent;

  AllergenesTab(this.onAllergensChangeEvent): super();

  @override
  _AllergenesTabState createState() => _AllergenesTabState(onAllergensChangeEvent);

}


class _AllergenesTabState extends State<AllergenesTab> {

  var onAllergensChangeEvent;
  _AllergenesTabState(this.onAllergensChangeEvent);

  List<String> allergeneTypeList = ['Pollens', 'Aliments'];
  Future<List<Allergen>> allergeneList;



  final dbHelper = DatabaseHelper.instance;
  final String deleateMsg = 'Êtes-vous sûr de vouloir supprimer cet allergène ?';
  final String title = "Liste d'allergènes";

  final String newItemMsg = 'Nouvel allergène';
  final String deleteSuccessfulMsg = 'Allergène supprimé avec succès';
  final String deleteFailedMsg = "Erreur lors de la suppression de l'allergène";
  final String editSuccessfulMsg = 'Allergène modifié avec succès';
  final String insertSuccessfulMsg = 'Allergène créé avec succès';
  final String editFailedMsg = "Erreur lors de l'édition de l'allergène";
  final String insertFailedMsg = "Erreur lors de la création de l'allergène";






  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[

        SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(0, 40, 0, 80),
            child: FutureBuilder<List<Allergen>>(
                future: refreshAllergenList(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
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
                                  }).then((onValue) {newAllergens(onValue);});
                            },
                            onLongPress: () {
                              showDialog(context: context, builder: (context) {
                                    return DeleteDialog(deleateMsg);
                                  }).then((onValue) {
                                    if (onValue) deleteAllergens(snapshot.data[i].id);
                                  });
                            },
                            leading: GestureDetector(onTap: (){
                              showDialog(context: context, builder: (context) {
                                return ColorPickerDialog();
                              }).then((onValue) {
                                if (onValue != null){
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
                                  Text(snapshot.data[i].id.toString(),style: TextStyle(color: Colors.white)),
                                ])
                                ),
                            title: Text(snapshot.data[i].name),
                            subtitle: Text(allergeneTypeList[snapshot.data[i].allergenType]),
                            trailing:
                                GestureDetector(
                              onTap: () {
                                showDialog(context: context, builder: (context) {
                                  return DeleteDialog(deleateMsg);
                                }).then((onValue) {
                                  if (onValue) deleteAllergens(snapshot.data[i].id);
                                });
                              },
                              child: Container(
                                child: Icon(Icons.clear),
                              ),
                            ),
                          ));
                        });
                  } else {
                    return Center(child: SizedBox(width: 100,height: 100,child: CircularProgressIndicator(),),);
                  }
                })),

        TabTitleBar(title),

        Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.all(10),
              child: FloatingActionButton(
                tooltip: newItemMsg,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AllergeneDialog(null);
                      }).then((onValue) {newAllergens(onValue);});
                },
                child: Icon(Icons.add),
              ),
            )),
      ],
    );
  }











  Future<List<Allergen>> refreshAllergenList() async {
    setState(() {allergeneList = dbHelper.getAllergens();});
    return allergeneList;
  }

  void deleteAllergens(int index) async {
    bool success = await dbHelper.deleteAllergen(index) > 0; // if deleted something
    if (success) {
      refreshAllergenList();
      onAllergensChangeEvent();
    }

    UiTools.newSnackBar(
        success?deleteSuccessfulMsg:deleteFailedMsg,
        success?Colors.green:Colors.redAccent, 1, context);
  }


  void newAllergens(Allergen returnedValue) async {
    if (returnedValue != null){
      bool isEdit = returnedValue.id != 0;

      int id = isEdit ? await dbHelper.updateAllergen(returnedValue.toJson()):
                        await dbHelper.insertAllergen(returnedValue.toJsonNoId());

      bool success = id>0;
      if(success) {
        refreshAllergenList();
        onAllergensChangeEvent();
      }

      UiTools.newSnackBar(
          success?(isEdit?editSuccessfulMsg:insertSuccessfulMsg):
                  (isEdit?editFailedMsg:insertFailedMsg),
          success?Colors.green:Colors.redAccent, 1, context);
    }
  }

  void updateAllergeneColor(Allergen tempValue, String color){ /** This should be optimised **/
    tempValue.color = color;
    dbHelper.updateAllergen(tempValue.toJson());
    refreshAllergenList();
    onAllergensChangeEvent();
  }




}