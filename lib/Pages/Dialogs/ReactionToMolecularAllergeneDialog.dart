import '../../Beings/MAllergeneReaction.dart';
import '../../Beings/MolecularAllergene.dart';
import '../../Beings/Reaction.dart';
import '../../Tools/database_helper.dart';
import 'package:flutter/material.dart';


class ReactionToMolecularAllergeneDialog extends StatefulWidget {
  Future<List<MolecularAllergene>> molecularAllergeneList;
  Future<List<Reaction>> reactionList;
  MAllergeneReaction mAllergeneReaction;
  ReactionToMolecularAllergeneDialog(this.mAllergeneReaction, this.molecularAllergeneList, this.reactionList);

  @override
  _ReactionToMolecularAllergeneDialogState createState() => _ReactionToMolecularAllergeneDialogState(mAllergeneReaction,molecularAllergeneList,reactionList);

}

class _ReactionToMolecularAllergeneDialogState extends State<ReactionToMolecularAllergeneDialog> {
  Future<List<MolecularAllergene>> molecularAllergeneList;
  Future<List<Reaction>> reactionList;

  MAllergeneReaction mAllergeneReaction;
  _ReactionToMolecularAllergeneDialogState(this.mAllergeneReaction, this.molecularAllergeneList, this.reactionList);

  final _formKey = GlobalKey<FormState>();
  String dialogTitle;
  MolecularAllergene _selectedMolecularAllergene;
  Reaction _selectedReaction;
  final dbHelper = DatabaseHelper.instance;


  @override
  Widget initState(){
    if(mAllergeneReaction != null){
      dialogTitle = 'Edit Reaction / Molecular Allergene Link';
      //adaptedTreatmentController.text = mAllergeneReaction.adapted_treatment;
      //_selectedReaction = _reactionLevelList[mAllergeneReaction.level];
      //_selectedMolecularAllergene = _reactionLevelList[mAllergeneReaction.level];
    } else {
      dialogTitle = 'New Reaction / Molecular Allergene Link';
      //adaptedTreatmentController.text = '';
      //_selectedReaction = _reactionLevelList[0];
      //_selectedMolecularAllergene = _reactionLevelList[0];
    }
    // molecularAllergeneList = dbHelper.getMolecularAllergenes();
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: ListView(shrinkWrap: true, children:[
    AlertDialog(title: Text(dialogTitle),
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


          FutureBuilder<List<MolecularAllergene>>(
              future: molecularAllergeneList,//refreshMolecularFamilyList(),
              builder: (context, snapshot) {
                //if (snapshot.hasError) return Text(snapshot.error);
                if (snapshot.hasData) {
                  initCurrentSelectedMolecularAllergene(mAllergeneReaction, snapshot.data);
                  return DropdownButtonFormField(decoration: new InputDecoration(icon: Icon(Icons.ac_unit)),
                      onChanged: (newValue) {setState(() {_selectedMolecularAllergene = newValue;});},
                      value: _selectedMolecularAllergene,//initCurrentSelectedMolecularFamily(molecularAllergene, snapshot.data),
                      items: snapshot.data.map((MolecularAllergene molecularAllergene) {
                      return DropdownMenuItem<MolecularAllergene>(child: Text(molecularAllergene.name), value:molecularAllergene);
                      }).toList(),
                      validator: (value) { if (value == null) { return 'Please create a molecular allergene first';} return null;},
                      );
                }
                return DropdownButtonFormField(items: null, onChanged: (newValue){},); //CircularProgressIndicator();
              }),




          FutureBuilder<List<Reaction>>(
              future: reactionList,//refreshMolecularFamilyList(),
              builder: (context, snapshot) {
                //if (snapshot.hasError) return Text(snapshot.error);
                if (snapshot.hasData) {
                  initCurrentSelectedReaction(mAllergeneReaction, snapshot.data);
                  return DropdownButtonFormField(decoration: new InputDecoration(icon: Icon(Icons.airline_seat_flat)),
                    onChanged: (newValue) {setState(() {_selectedReaction = newValue;});},
                    value: _selectedReaction,//initCurrentSelectedMolecularFamily(molecularAllergene, snapshot.data),
                    items: snapshot.data.map((Reaction reaction) {
                      return DropdownMenuItem<Reaction>(child: Text(reaction.adapted_treatment), value:reaction);
                    }).toList(),
                    validator: (value) { if (value == null) { return 'Please create a reaction first';} return null;},
                  );
                }
                return DropdownButtonFormField(items: null, onChanged: (newValue){},); //CircularProgressIndicator();
              }),

        ],),),

      actions: <Widget>[
        MaterialButton(elevation: 5.0,child: Text('Confirm'), onPressed: () async {
          if (_formKey.currentState.validate()) {
            MAllergeneReaction tempMAllergeneReaction = MAllergeneReaction(
                mAllergeneReaction==null?0:mAllergeneReaction.id,
                _selectedMolecularAllergene.id,
                _selectedReaction.id);
            Navigator.of(context).pop(tempMAllergeneReaction);
          }
        },),

        MaterialButton(elevation: 5.0,child: Text('Cancel'), onPressed: (){
          Navigator.of(context).pop(null);//'0');// 0 = canceled && null/2 = error
        },),
      ],




    ),
    ],),);
  }


  void initCurrentSelectedMolecularAllergene(MAllergeneReaction mAllergeneReaction, List<MolecularAllergene> molecularAllergeneList) {
    if(_selectedMolecularAllergene == null){
      if (mAllergeneReaction != null) // is edit
        _selectedMolecularAllergene = getSelectedMolecularAllergeneFromID(mAllergeneReaction.molecularAllergeneID,molecularAllergeneList);
      else  // is new
        _selectedMolecularAllergene = molecularAllergeneList.length>0?molecularAllergeneList.first:null;
    }
  }


  void initCurrentSelectedReaction(MAllergeneReaction mAllergeneReaction, List<Reaction> reactionList) {
    if(_selectedReaction == null){
      if (mAllergeneReaction != null) // is edit
        _selectedReaction = getSelectedReactionFromID(mAllergeneReaction.reactionID,reactionList);
      else  // is new
        _selectedReaction = reactionList.length>0?reactionList.first:null;
    }
  }

  MolecularAllergene getSelectedMolecularAllergeneFromID(int molecularAllergeneId, List<MolecularAllergene> molecularAllergeneList){
    for(int i = 0;i<molecularAllergeneList.length;i++){
      if ( molecularAllergeneId == molecularAllergeneList[i].id)
        return molecularAllergeneList[i];
    }
    return null;
  }


  Reaction getSelectedReactionFromID(int reactionId, List<Reaction> reactionList){
    for(int i = 0;i<reactionList.length;i++){
      if ( reactionId == reactionList[i].id)
        return reactionList[i];
    }
    return null;
  }

}