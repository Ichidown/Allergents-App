import 'package:allergensapp/Beings/MolecularFamily.dart';
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


  @override
  Widget initState(){
    if(molecularFamily != null){
      dialogTitle = 'Edit Molecular family';
      molecularFamilyController.text = molecularFamily.name;
    } else{
      dialogTitle = 'New Molecular family';
      molecularFamilyController.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: ListView(shrinkWrap: true, children:[
    AlertDialog(title: Text(dialogTitle),
      content:Form( key: _formKey,
        child: Column(children: <Widget>[

          TextFormField(controller:molecularFamilyController, decoration: InputDecoration(labelText: 'Molecular Family Name',),
            validator: (value) { if (value.isEmpty) { return 'Please enter some text';} return null;},),

        ],),),

      actions: <Widget>[
        MaterialButton(elevation: 5.0,child: Text('Confirm'), onPressed: () async {
          if (_formKey.currentState.validate()) {
            MolecularFamily tempAllergene = MolecularFamily(molecularFamily==null?0:molecularFamily.id,
                molecularFamilyController.text,
                molecularFamily==null?'0xff42a5f5':molecularFamily.color);
            Navigator.of(context).pop(tempAllergene);
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