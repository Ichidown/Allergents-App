import 'package:allergensapp/Beings/MolecularAllergene.dart';
import 'package:allergensapp/Beings/MolecularFamily.dart';
import 'package:allergensapp/Tools/database_helper.dart';
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
    if (molecularAllergene != null) {
      dialogTitle = 'Edit Molecular allergene';
      molecularAllergeneNameController.text = molecularAllergene.name;
      //_selectedMolecularFamily = molecularFamilyList.then(onValue);/** GET ID **/ //_molecularFamilyList[allergene.allergeneType];
    } else {
      dialogTitle = 'New Molecular allergene';
      molecularAllergeneNameController.text = '';
      //_selectedMolecularFamily = _molecularAllergeneList.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(margin: EdgeInsets.all(0),padding : EdgeInsets.all(0),alignment: Alignment.center, child:

    SingleChildScrollView(child:
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
            future: refreshMolecularFamilyList(),
            builder: (context, snapshot) {
              if (snapshot.hasError) return Text(snapshot.error);
              if (snapshot.hasData) {
                return DropdownButtonFormField(decoration: new InputDecoration(icon: Icon(Icons.ac_unit)),
                  value: initCurrentSelectedMolecularFamily(molecularAllergene, snapshot.data),
                  onChanged: (newValue) {setState(() {_selectedMolecularFamily = newValue;});},
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
            MolecularAllergene tempAllergene = MolecularAllergene(molecularAllergene==null?0:molecularAllergene.id,
                molecularAllergeneNameController.text, _selectedMolecularFamily.id,
                molecularAllergene==null?'0xff42a5f5':molecularAllergene.color);
            Navigator.of(context).pop(tempAllergene);
          }
        },),

        MaterialButton(elevation: 5.0,child: Text('Cancel'), onPressed: (){
          Navigator.of(context).pop(null);//'0');// 0 = canceled && null/2 = error
        },),
      ],
    ),
    )
    );
  }


  MolecularFamily initCurrentSelectedMolecularFamily(MolecularAllergene molecularAllergene, List<MolecularFamily> molecularFamilyList) {

      if (molecularAllergene != null) // is edit
        _selectedMolecularFamily = getSelectedMolecularFamilyFromID(molecularAllergene.molecular_family_id,molecularFamilyList);
      else  // is new
        _selectedMolecularFamily = molecularFamilyList.length>0?molecularFamilyList.first:null;

    return _selectedMolecularFamily;
  }


  MolecularFamily getSelectedMolecularFamilyFromID(int molecularFamilyId, List<MolecularFamily> molecularFamilyList){
    for(int i = 0;i<molecularFamilyList.length;i++){
      if ( molecularFamilyId == molecularFamilyList[i].id)
        return molecularFamilyList[i];
    }
    return null;
  }




  Future<List<MolecularFamily>> refreshMolecularFamilyList() async {
    setState(() {molecularFamilyList = dbHelper.getMolecularFamilies();});
    return molecularFamilyList;
  }
}