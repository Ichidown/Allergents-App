import 'package:allergensapp/Beings/Allergene.dart';
import 'package:allergensapp/Beings/MFamilyAllergene.dart';
import 'package:allergensapp/Beings/MolecularFamily.dart';
import 'package:allergensapp/Tools/database_helper.dart';
import 'package:flutter/material.dart';


class MolecularFamilyToAllergeneDialog extends StatefulWidget {
  Future<List<Allergene>> allergeneList;
  Future<List<MolecularFamily>> molecularFamilyList;
  MFamilyAllergene mFamilyAllergene;
  MolecularFamilyToAllergeneDialog(this.mFamilyAllergene, this.allergeneList, this.molecularFamilyList);

  @override
  _MolecularFamilyToAllergeneDialogState createState() => _MolecularFamilyToAllergeneDialogState(mFamilyAllergene,allergeneList,molecularFamilyList);

}

class _MolecularFamilyToAllergeneDialogState extends State<MolecularFamilyToAllergeneDialog> {
  Future<List<Allergene>> allergeneList;
  Future<List<MolecularFamily>> molecularFamilyList;

  MFamilyAllergene mFamilyAllergene;
  _MolecularFamilyToAllergeneDialogState(this.mFamilyAllergene, this.allergeneList, this.molecularFamilyList);
  final _formKey = GlobalKey<FormState>();
  Allergene _selectedAllergene_1,_selectedAllergene_2;
  MolecularFamily _selectedMolecularFamily;
  final dbHelper = DatabaseHelper.instance;


  final String dialogEditTitle = 'Edit Molecular Family To Allergene link';
  final String dialogInsertTitle = 'New Molecular Family To Allergene link';
  final String confirmBtnText = 'Confirm';
  final String cancelBtnText = 'Cancel';


  /*@override
  Widget initState(){
    if(mAllergeneReaction != null){
      //adaptedTreatmentController.text = mAllergeneReaction.adapted_treatment;
      //_selectedReaction = _reactionLevelList[mAllergeneReaction.level];
      //_selectedMolecularAllergene = _reactionLevelList[mAllergeneReaction.level];
    } else {
      //adaptedTreatmentController.text = '';
      //_selectedReaction = _reactionLevelList[0];
      //_selectedMolecularAllergene = _reactionLevelList[0];
    }
    // molecularAllergeneList = dbHelper.getMolecularAllergenes();
  }*/

  @override
  Widget build(BuildContext context) {
    return Center(child: ListView(shrinkWrap: true, children:[
    AlertDialog(title: Text(mFamilyAllergene != null? dialogEditTitle : dialogInsertTitle),
      content:Form( key: _formKey,
        child: Column(children: <Widget>[
/*
          DropdownButtonFormField(value: _selectedReaction,decoration: new InputDecoration(icon: Icon(Icons.transfer_within_a_station)),
            onChanged: (newValue) { setState(() {_selectedReaction = newValue;});},
            items: _reactionLevelList.map((location) { return DropdownMenuItem(child: new Text(location), value: location,);}).toList(),
          ),

          DropdownButtonFormField(value: _selectedMolecularAllergene,decoration: new InputDecoration(icon: Icon(Icons.transfer_within_a_station)),
            onChanged: (newValue) { setState(() {_selectedMolecularAllergene = newValue;});},
            items: _reactionLevelList.map((location) { return DropdownMenuItem(child: new Text(location), value: location,);}).toList(),
          ),
*/


          FutureBuilder<List<Allergene>>(
              future: allergeneList,//refreshMolecularFamilyList(),
              builder: (context, snapshot) {
                //if (snapshot.hasError) return Text(snapshot.error);
                if (snapshot.hasData) {
                  initCurrentSelectedAllergene_1(mFamilyAllergene, snapshot.data);
                  return DropdownButtonFormField(decoration: new InputDecoration(icon: Icon(Icons.ac_unit)),
                    onChanged: (newValue) {setState(() {_selectedAllergene_1 = newValue;});},
                    value: _selectedAllergene_1,//initCurrentSelectedMolecularFamily(molecularAllergene, snapshot.data),
                    items: snapshot.data.map((Allergene molecularAllergene) {
                      return DropdownMenuItem<Allergene>(child: Text(molecularAllergene.name), value:molecularAllergene);
                    }).toList(),
                    validator: (value) { if (value == null) { return 'Please create an allergene first';} return null;},
                  );
                }
                return DropdownButtonFormField(items: null, onChanged: (newValue){},); //CircularProgressIndicator();
              }),



          FutureBuilder<List<Allergene>>(
              future: allergeneList,//refreshMolecularFamilyList(),
              builder: (context, snapshot) {
                //if (snapshot.hasError) return Text(snapshot.error);
                if (snapshot.hasData) {
                  initCurrentSelectedAllergene_2(mFamilyAllergene, snapshot.data);
                  return DropdownButtonFormField(decoration: new InputDecoration(icon: Icon(Icons.ac_unit)),
                    onChanged: (newValue) {setState(() {_selectedAllergene_2 = newValue;});},
                    value: _selectedAllergene_2,//initCurrentSelectedMolecularFamily(molecularAllergene, snapshot.data),
                    items: snapshot.data.map((Allergene molecularAllergene) {
                      return DropdownMenuItem<Allergene>(child: Text(molecularAllergene.name), value:molecularAllergene);
                    }).toList(),
                    validator: (value) { if (value == null) { return 'Please create an allergene first';} return null;},
                  );
                }
                return DropdownButtonFormField(items: null, onChanged: (newValue){},); //CircularProgressIndicator();
              }),




          FutureBuilder<List<MolecularFamily>>(
              future: molecularFamilyList,//refreshMolecularFamilyList(),
              builder: (context, snapshot) {
                //if (snapshot.hasError) return Text(snapshot.error);
                if (snapshot.hasData) {
                  initCurrentSelectedMolecularFamily(mFamilyAllergene, snapshot.data);
                  return DropdownButtonFormField(decoration: new InputDecoration(icon: Icon(Icons.airline_seat_flat)),
                    onChanged: (newValue) {setState(() {_selectedMolecularFamily = newValue;});},
                    value: _selectedMolecularFamily,//initCurrentSelectedMolecularFamily(molecularAllergene, snapshot.data),
                    items: snapshot.data.map((MolecularFamily reaction) {
                      return DropdownMenuItem<MolecularFamily>(child: Text(reaction.name), value:reaction);
                    }).toList(),
                    validator: (value) { if (value == null) { return 'Please create a molecular family first';} return null;},
                  );
                }
                return DropdownButtonFormField(items: null, onChanged: (newValue){},); //CircularProgressIndicator();
              }),

        ],),),

      actions: <Widget>[
        MaterialButton(elevation: 5.0,child: Text(confirmBtnText), onPressed: () async {
          if (_formKey.currentState.validate()) {
            MFamilyAllergene tempMFamilyAllergene = MFamilyAllergene(
                mFamilyAllergene==null?0:mFamilyAllergene.id,
                _selectedAllergene_1.id,
                _selectedAllergene_2.id,
                _selectedMolecularFamily.id);
            Navigator.of(context).pop(tempMFamilyAllergene);
          }
        },),

        MaterialButton(elevation: 5.0,child: Text(cancelBtnText), onPressed: (){
          Navigator.of(context).pop(null);//'0');// 0 = canceled && null/2 = error
        },),
      ],




    ),
    ],),);
  }


  void initCurrentSelectedAllergene_1(MFamilyAllergene mFamilyAllergene, List<Allergene> allergeneList) {
    if(_selectedAllergene_1 == null){
      if (mFamilyAllergene != null) // is edit
        _selectedAllergene_1 = getSelectedAllergeneFromID(mFamilyAllergene.allergeneID1,allergeneList);
      else  // is new
        _selectedAllergene_1 = allergeneList.length>0?allergeneList.first:null;
    }
  }


  void initCurrentSelectedAllergene_2(MFamilyAllergene mAllergeneReaction, List<Allergene> allergeneList) {
    if(_selectedAllergene_2 == null){
      if (mAllergeneReaction != null) // is edit
        _selectedAllergene_2 = getSelectedAllergeneFromID(mAllergeneReaction.allergeneID2,allergeneList);
      else  // is new
        _selectedAllergene_2 = allergeneList.length>0?allergeneList.first:null;
    }
  }


  void initCurrentSelectedMolecularFamily(MFamilyAllergene mAllergeneReaction, List<MolecularFamily> reactionList) {
    if(_selectedMolecularFamily == null){
      if (mAllergeneReaction != null) // is edit
        _selectedMolecularFamily = getSelectedMolecularFamilyFromID(mAllergeneReaction.molecularFamilyID,reactionList);
      else  // is new
        _selectedMolecularFamily = reactionList.length>0?reactionList.first:null;
    }
  }


  Allergene getSelectedAllergeneFromID(int molecularAllergeneId, List<Allergene> molecularAllergeneList){
    for(int i = 0;i<molecularAllergeneList.length;i++){
      if ( molecularAllergeneId == molecularAllergeneList[i].id)
        return molecularAllergeneList[i];
    }
    return null;
  }


  MolecularFamily getSelectedMolecularFamilyFromID(int reactionId, List<MolecularFamily> mFamilyList){
    for(int i = 0;i<mFamilyList.length;i++){
      if ( reactionId == mFamilyList[i].id)
        return mFamilyList[i];
    }
    return null;
  }

}