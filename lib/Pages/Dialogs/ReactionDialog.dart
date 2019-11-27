import 'package:allergensapp/Beings/Reaction.dart';
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
  static List<String> _reactionLevelList = ['Light', 'Moderate','Severe']; // Option 2
  String dialogTitle,_selectedReactionLevel;


  @override
  Widget initState(){
    if(reaction != null){
      dialogTitle = 'Edit Reaction';
      adaptedTreatmentController.text = reaction.adapted_treatment;
      _selectedReactionLevel = _reactionLevelList[reaction.level];
    } else{
      dialogTitle = 'New Reaction';
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

          TextFormField(controller:adaptedTreatmentController, decoration: InputDecoration(labelText: 'Adapted Treatment',),
            validator: (value) { if (value.isEmpty) { return 'Please enter some text';} return null;},),

          DropdownButtonFormField(value: _selectedReactionLevel,decoration: new InputDecoration(icon: Icon(Icons.transfer_within_a_station)),
            onChanged: (newValue) { setState(() {_selectedReactionLevel = newValue;});},
            items: _reactionLevelList.map((location) { return DropdownMenuItem(child: new Text(location), value: location,);}).toList(),
          ),

        ],),),

      actions: <Widget>[
        MaterialButton(elevation: 5.0,child: Text('Confirm'), onPressed: () async {
          if (_formKey.currentState.validate()) {
            Reaction tempReaction = Reaction(reaction==null?0:reaction.id,
                _reactionLevelList.indexOf(_selectedReactionLevel),
                adaptedTreatmentController.text);
            Navigator.of(context).pop(tempReaction);
          }
        },),

        MaterialButton(elevation: 5.0,child: Text('Cancel'), onPressed: (){
          Navigator.of(context).pop(null);//'0');// 0 = canceled && null/2 = error
        },),
      ],
    ),
    ],),);
  }

}