import 'package:allergensapp/Tools/GeneralTools.dart';

import '../../Beings/MolecularFamily.dart';
import 'package:flutter/material.dart';


class MolecularFamilyDialog extends StatefulWidget {
  MolecularFamily molecularFamily;
  MolecularFamilyDialog(this.molecularFamily);

  @override
  _MolecularFamilyDialogState createState() => _MolecularFamilyDialogState(molecularFamily);
}

class _MolecularFamilyDialogState extends State<MolecularFamilyDialog> {
  MolecularFamily molecularFamily;
  _MolecularFamilyDialogState(this.molecularFamily);

  final _formKey = GlobalKey<FormState>();
  TextEditingController molecularFamilyController = TextEditingController();
  String dialogTitle;


  final String editDialogTitle = 'Modifier la famille moléculaire';
  final String insertDialogTitle = 'Nouvelle famille moléculaire';

  final String validatorText1 = "S'il vous plaît entrer quelque chose";
  final String textFieldLabel = 'Nom de famille moléculaire';

  final String confirmBtnText = 'Confirmer';
  final String cancelBtnText = 'Annuler';


  @override
  Widget initState(){
    if(molecularFamily != null){
      dialogTitle = editDialogTitle;
      molecularFamilyController.text = molecularFamily.name;
    } else{
      dialogTitle = insertDialogTitle;
      molecularFamilyController.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: ListView(shrinkWrap: true, children:[
    AlertDialog(title: Text(dialogTitle),
      content:Form( key: _formKey,
        child: Column(children: <Widget>[

          TextFormField(controller:molecularFamilyController, decoration: InputDecoration(labelText: textFieldLabel,),
            validator: (value) { if (value.isEmpty) { return validatorText1;} return null;},),

        ],),),

      actions: <Widget>[
        MaterialButton(elevation: 5.0,child: Text(confirmBtnText), onPressed: () async {
          if (_formKey.currentState.validate()) {
            MolecularFamily tempAllergene = MolecularFamily(molecularFamily==null?0:molecularFamily.id,
                molecularFamilyController.text,
                molecularFamily==null?GeneralTools.getRandomColor():molecularFamily.color,0);
            Navigator.of(context).pop(tempAllergene);
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