import '../../Beings/MAllergenReaction.dart';
import '../../Beings/MolecularAllergen.dart';
import '../../Beings/Reaction.dart';
import '../../Tools/database_helper.dart';
import 'package:flutter/material.dart';


class ReactionToMolecularAllergeneDialog extends StatefulWidget {
  Future<List<MolecularAllergen>> molecularAllergeneList;
  Future<List<Reaction>> reactionList;
  MAllergenReaction mAllergeneReaction;
  ReactionToMolecularAllergeneDialog(this.mAllergeneReaction, this.molecularAllergeneList, this.reactionList);

  @override
  _ReactionToMolecularAllergeneDialogState createState() => _ReactionToMolecularAllergeneDialogState(mAllergeneReaction,molecularAllergeneList,reactionList);

}

class _ReactionToMolecularAllergeneDialogState extends State<ReactionToMolecularAllergeneDialog> {
  Future<List<MolecularAllergen>> molecularAllergeneList;
  Future<List<Reaction>> reactionList;

  MAllergenReaction mAllergeneReaction;
  _ReactionToMolecularAllergeneDialogState(this.mAllergeneReaction, this.molecularAllergeneList, this.reactionList);

  final _formKey = GlobalKey<FormState>();
  String dialogTitle;
  MolecularAllergen _selectedMolecularAllergene;
  Reaction _selectedReaction;
  final dbHelper = DatabaseHelper.instance;


  final String confirmBtnText = 'Confirmer';
  final String cancelBtnText = 'Annuler';

  final String validatorText1 = "Veuillez créer un allergène moléculaire d'abord";
  final String validatorText2 = "Veuillez créer une réaction d'abord";

  final String dialogEditTitle = "Modifier le lien réactif / allergène moléculaire";
  final String dialogInsertTitle = 'Nouveau lien réaction / allergène moléculaire';


  @override
  Widget initState(){
    if(mAllergeneReaction != null)
      dialogTitle = dialogEditTitle;
    else
      dialogTitle = dialogInsertTitle;
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: ListView(shrinkWrap: true, children:[
    AlertDialog(title: Text(dialogTitle),
      content:Form( key: _formKey,
        child: Column(children: <Widget>[

          FutureBuilder<List<MolecularAllergen>>(
              future: molecularAllergeneList,//refreshMolecularFamilyList(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  initCurrentSelectedMolecularAllergene(mAllergeneReaction, snapshot.data);
                  return DropdownButtonFormField(isExpanded: true,decoration: new InputDecoration(icon: Icon(Icons.bubble_chart)),
                      onChanged: (newValue) {setState(() {_selectedMolecularAllergene = newValue;});},
                      value: _selectedMolecularAllergene,//initCurrentSelectedMolecularFamily(molecularAllergene, snapshot.data),
                      items: snapshot.data.map((MolecularAllergen molecularAllergene) {
                      return DropdownMenuItem<MolecularAllergen>(child: Text(molecularAllergene.name), value:molecularAllergene);
                      }).toList(),
                      validator: (value) { if (value == null) { return validatorText1;} return null;},
                      );
                }
                return DropdownButtonFormField(items: null, onChanged: (newValue){},); //CircularProgressIndicator();
              }),




          FutureBuilder<List<Reaction>>(
              future: reactionList,//refreshMolecularFamilyList(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  initCurrentSelectedReaction(mAllergeneReaction, snapshot.data);
                  return DropdownButtonFormField(isExpanded: true,decoration: new InputDecoration(icon: Icon(Icons.airline_seat_flat)),
                    onChanged: (newValue) {setState(() {_selectedReaction = newValue;});},
                    value: _selectedReaction,//initCurrentSelectedMolecularFamily(molecularAllergene, snapshot.data),
                    items: snapshot.data.map((Reaction reaction) {
                      return DropdownMenuItem<Reaction>(child: Text(reaction.adaptedTreatment), value:reaction);
                    }).toList(),
                    validator: (value) { if (value == null) { return validatorText2;} return null;},
                  );
                }
                return DropdownButtonFormField(items: null, onChanged: (newValue){},); //CircularProgressIndicator();
              }),

        ],),),

      actions: <Widget>[
        MaterialButton(elevation: 5.0,child: Text(confirmBtnText), onPressed: () async {
          if (_formKey.currentState.validate()) {
            MAllergenReaction tempMAllergeneReaction = MAllergenReaction(
                mAllergeneReaction==null?0:mAllergeneReaction.id,
                _selectedMolecularAllergene.id,
                _selectedReaction.id);
            Navigator.of(context).pop(tempMAllergeneReaction);
          }
        },),

        MaterialButton(elevation: 5.0,child: Text(cancelBtnText), onPressed: (){
          Navigator.of(context).pop(null);//'0');// 0 = canceled && null/2 = error
        },),
      ],




    ),
    ],),);
  }


  void initCurrentSelectedMolecularAllergene(MAllergenReaction mAllergeneReaction, List<MolecularAllergen> molecularAllergeneList) {
    if(_selectedMolecularAllergene == null){
      if (mAllergeneReaction != null) // is edit
        _selectedMolecularAllergene = getSelectedMolecularAllergeneFromID(mAllergeneReaction.molecularAllergenID,molecularAllergeneList);
      else  // is new
        _selectedMolecularAllergene = molecularAllergeneList.length>0?molecularAllergeneList.first:null;
    }
  }


  void initCurrentSelectedReaction(MAllergenReaction mAllergeneReaction, List<Reaction> reactionList) {
    if(_selectedReaction == null){
      if (mAllergeneReaction != null) // is edit
        _selectedReaction = getSelectedReactionFromID(mAllergeneReaction.reactionID,reactionList);
      else  // is new
        _selectedReaction = reactionList.length>0?reactionList.first:null;
    }
  }

  MolecularAllergen getSelectedMolecularAllergeneFromID(int molecularAllergeneId, List<MolecularAllergen> molecularAllergeneList){
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