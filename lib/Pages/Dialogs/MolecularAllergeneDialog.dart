import 'package:allergensapp/Tools/GeneralTools.dart';

import '../../Beings/MolecularAllergene.dart';
import '../../Beings/MolecularFamily.dart';
import '../../Tools/database_helper.dart';
import 'package:flutter/material.dart';


class MolecularAllergeneDialog extends StatefulWidget {
  MolecularAllergene molecularAllergene;
  Future<List<MolecularFamily>> molecularFamilyList;
  MolecularAllergeneDialog(this.molecularAllergene,this.molecularFamilyList);

  @override
  _MolecularAllergeneDialogState createState() => _MolecularAllergeneDialogState(molecularAllergene,molecularFamilyList);

}

class _MolecularAllergeneDialogState extends State<MolecularAllergeneDialog> {
  MolecularAllergene molecularAllergene;
  Future<List<MolecularFamily>> molecularFamilyList;
  _MolecularAllergeneDialogState(this.molecularAllergene, this.molecularFamilyList);

  final dbHelper = DatabaseHelper.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController molecularAllergeneNameController = TextEditingController();
  MolecularFamily _selectedMolecularFamily;
  String dialogTitle;


  @override
  Widget initState() {
    super.initState();
    if (molecularAllergene != null) {
      dialogTitle = 'Edit Molecular allergene';
      molecularAllergeneNameController.text = molecularAllergene.name;
    } else {
      dialogTitle = 'New Molecular allergene';
      molecularAllergeneNameController.text = '';
    }
    // molecularFamilyList = dbHelper.getMolecularFamilies();
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: ListView(shrinkWrap: true, children:[
    AlertDialog(title: Text(dialogTitle),
      content:Form( key: _formKey,
        child: Column(children: <Widget>[

          TextFormField(controller:molecularAllergeneNameController, decoration: InputDecoration(labelText: 'Molecular Allergene Name',),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },),



          FutureBuilder<List<MolecularFamily>>(
            future: molecularFamilyList,//refreshMolecularFamilyList(),
            builder: (context, snapshot) {
              //if (snapshot.hasError) return Text(snapshot.error);
              if (snapshot.hasData) {
                initCurrentSelectedMolecularFamily(molecularAllergene, snapshot.data);

                return DropdownButtonFormField(decoration: new InputDecoration(icon: Icon(Icons.category)),
                  onChanged: (newValue) {setState(() {_selectedMolecularFamily = newValue;});},
                  value: _selectedMolecularFamily,//initCurrentSelectedMolecularFamily(molecularAllergene, snapshot.data),
                  items: snapshot.data.map((MolecularFamily molecularFamily) {
                    return DropdownMenuItem<MolecularFamily>(child: Text(molecularFamily.name), value: molecularFamily);
                  }).toList(),
                );
              }
              return DropdownButtonFormField(items: null, onChanged: (newValue){},); //CircularProgressIndicator();
            })



        ],),),

      actions: <Widget>[
        MaterialButton(elevation: 5.0,child: Text('Confirm'), onPressed: () async {
          print(_selectedMolecularFamily.name);
          if (_formKey.currentState.validate()) {
            MolecularAllergene tempAllergene = MolecularAllergene(
                molecularAllergene==null?0:molecularAllergene.id,
                molecularAllergeneNameController.text,
                _selectedMolecularFamily.id,
                molecularAllergene==null?GeneralTools.getRandomColor():molecularAllergene.color);
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











  void initCurrentSelectedMolecularFamily(MolecularAllergene molecularAllergene, List<MolecularFamily> molecularFamilyList) {
    if(_selectedMolecularFamily == null){
      if (molecularAllergene != null) // is edit
        _selectedMolecularFamily = getSelectedMolecularFamilyFromID(molecularAllergene.molecular_family_id,molecularFamilyList);
      else  // is new
        _selectedMolecularFamily = molecularFamilyList.length>0?molecularFamilyList.first:null;
    }
  }


  MolecularFamily getSelectedMolecularFamilyFromID(int molecularFamilyId, List<MolecularFamily> molecularFamilyList){
    for(int i = 0;i<molecularFamilyList.length;i++){
      if ( molecularFamilyId == molecularFamilyList[i].id)
        return molecularFamilyList[i];
    }
    return null;
  }




  /*Future<List<MolecularFamily>> refreshMolecularFamilyList() async {
    setState(() {molecularFamilyList = dbHelper.getMolecularFamilies();});
    return molecularFamilyList;
  }*/
}