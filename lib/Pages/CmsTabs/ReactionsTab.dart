import 'package:allergensapp/Widgets/TabTitleBar.dart';

import '../../Beings/Reaction.dart';
import '../../Pages/Dialogs/DeleteDialog.dart';
import '../../Pages/Dialogs/ReactionDialog.dart';
import '../../Tools/UiTools.dart';
import '../../Tools/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ReactionsTab extends StatefulWidget {
  @override
  _ReactionsTabState createState() => _ReactionsTabState();
}

class _ReactionsTabState extends State<ReactionsTab> {
  List<String> levelList = UiTools.getReactionLvlList();//['Light', 'Moderate','Severe'];
  Future<List<Reaction>> reactionList;
  final dbHelper = DatabaseHelper.instance;




  final String deleateMsg = 'Are you sure you want to deleate this reaction ?';
  final String title = 'Reaction / Adapted treatment list';

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: <Widget>[

        SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(0, 40, 0, 80),
            child: FutureBuilder<List<Reaction>>(
                future: refreshReaction(),
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
                                        return ReactionDialog(snapshot.data[i]);
                                      }).then((onValue) {newReaction(onValue);});
                                },
                                onLongPress: () {
                                  showDialog(context: context, builder: (context) {
                                    return DeleteDialog(deleateMsg);
                                  }).then((onValue) {
                                    if (onValue) deleteReaction(snapshot.data[i].id);
                                  });
                                },
                                leading: Stack( alignment: Alignment.center,
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                          color: snapshot.data[i].level==0?Colors.greenAccent:
                                          snapshot.data[i].level==1?Colors.amberAccent:
                                          Colors.redAccent,
                                          shape: BoxShape.circle,
                                        ),
                                        width: 50,
                                      ),
                                      Text(snapshot.data[i].id.toString()),
                                    ]),

                                title: Text(snapshot.data[i].adapted_treatment),
                                subtitle: Text(levelList[snapshot.data[i].level]),
                                trailing:

                                GestureDetector(
                                  onTap: () {
                                    showDialog(context: context, builder: (context) {
                                      return DeleteDialog(deleateMsg);
                                    }).then((onValue) {
                                      if (onValue) deleteReaction(snapshot.data[i].id);
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

        TabTitleBar(title),

        Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.all(10),
              child: FloatingActionButton(
                tooltip: 'New Reaction',
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return ReactionDialog(null);
                      }).then((onValue) {newReaction(onValue);});
                }
                ,
                child: Icon(Icons.add),
              ),
            )),
      ],
    );
  }











  Future<List<Reaction>> refreshReaction() async {
    setState(() {reactionList = dbHelper.getReactions();});
    return reactionList;
  }

  void deleteReaction(int index) async {
    bool success = await dbHelper.deleteReaction(index) > 0; // if deleted something
    if (success) refreshReaction();

    UiTools.newSnackBar(
        success?'Reaction deleted successfully':'Error while deleting the reaction',
        success?Colors.green:Colors.redAccent, 1, context);
  }


  void newReaction(Reaction returnedValue) async {
    


    if (returnedValue != null){
      bool isEdit = returnedValue.id != 0;

      int id = isEdit ? await dbHelper.updateReaction(returnedValue.toJson()):
      await dbHelper.insertReaction(returnedValue.toJsonNoId());

      bool success = id>0;
      if(success) refreshReaction();

      UiTools.newSnackBar(
          success?(isEdit?'Reaction edited successfully':'Reaction created successfully'):
          (isEdit?'Error while editing the reaction':'Error while creating the reaction'),
          success?Colors.green:Colors.redAccent, 1, context);
    }
  }



}