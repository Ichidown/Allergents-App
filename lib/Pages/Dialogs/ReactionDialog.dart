import 'package:allergensapp/Tools/UiTools.dart';

import '../../Beings/Reaction.dart';
import 'package:flutter/material.dart';


class ReactionDialog extends StatefulWidget {
  Reaction reaction;
  ReactionDialog(this.reaction);

  @override
  _ReactionDialogState createState() => _ReactionDialogState(reaction);

}

class _ReactionDialogState extends State<ReactionDialog> {
  Reaction reaction;
  _ReactionDialogState(this.reaction);

  final _formKey = GlobalKey<FormState>();
  TextEditingController adaptedTreatmentController = TextEditingController();
  static List<String> _reactionLevelList = UiTools.getReactionLvlList();//= ['Light', 'Moderate','Severe'];
  String dialogTitle,_selectedReactionLevel;


  final String validatorText1 = "S'il vous plaît entrer quelque chose";
  final String textFieldLabel = 'Traitement adapté';

  final String confirmBtnText = 'Confirmer';
  final String cancelBtnText = 'Annuler';

  final String dialogEditTitle = "Modifier la réaction";
  final String dialogInsertTitle = 'Nouvelle réaction';



  @override
  Widget initState(){
    if(reaction != null){
      dialogTitle = dialogEditTitle;
      adaptedTreatmentController.text = reaction.adaptedTreatment;
      _selectedReactionLevel = _reactionLevelList[reaction.level];
    } else{
      dialogTitle = dialogInsertTitle;
      adaptedTreatmentController.text = '';
      _selectedReactionLevel = _reactionLevelList[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: ListView(shrinkWrap: true, children:[
    AlertDialog(title: Text(dialogTitle),
      content:Form( key: _formKey,
        child: Column(children: <Widget>[

          TextFormField(controller:adaptedTreatmentController, decoration: InputDecoration(labelText: textFieldLabel,),
            validator: (value) { if (value.isEmpty) { return validatorText1;} return null;},),

          DropdownButtonFormField(value: _selectedReactionLevel,isExpanded: true,decoration: new InputDecoration(icon: Icon(Icons.transfer_within_a_station)),
            onChanged: (newValue) { setState(() {_selectedReactionLevel = newValue;});},
            items: _reactionLevelList.map((location) { return DropdownMenuItem(child: new Text(location), value: location,);}).toList(),
          ),

        ],),),

      actions: <Widget>[
        MaterialButton(elevation: 5.0,child: Text(confirmBtnText), onPressed: () async {
          if (_formKey.currentState.validate()) {
            Reaction tempReaction = Reaction(reaction==null?0:reaction.id,
                _reactionLevelList.indexOf(_selectedReactionLevel),
                adaptedTreatmentController.text);
            Navigator.of(context).pop(tempReaction);
          }
        },),

        MaterialButton(elevation: 5.0,child: Text(cancelBtnText), onPressed: (){
          Navigator.of(context).pop(null);//'0');// 0 = canceled && null/2 = error
        },),
      ],
    ),
    ],),);
  }

}