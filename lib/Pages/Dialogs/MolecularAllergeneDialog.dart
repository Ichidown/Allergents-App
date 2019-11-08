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
  final dbHelper = DatabaseHelper.instance;
  MolecularAllergene molecularAllergene;
  Future<List<MolecularFamily>> molecularFamilyList;
  _MolecularAllergeneDialogState(this.molecularAllergene, this.molecularFamilyList);

  //List<String> dropDownList = ['DD1', 'DD2','DD3'];

  final _formKey = GlobalKey<FormState>();
  TextEditingController molecularAllergeneNameController = TextEditingController();
  //static List<String> _molecularAllergeneList = ['Familly 1', 'Familly 2','Familly 3']; // Option 2
  //Future<List<MolecularFamily>> molecularFamilyList;
  String dialogTitle,_selectedMolecularFamily;


  @override
  Widget initState(){
    if(molecularAllergene != null){
      dialogTitle = 'Edit Molecular allergene';
      molecularAllergeneNameController.text = molecularAllergene.name;
      //_selectedMolecularFamily = molecularFamilyList.then(onValue);/** GET ID **/ //_molecularFamilyList[allergene.allergeneType];
    } else{
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
            validator: (value) { if (value.isEmpty) { return 'Please enter some text';} return null;},),


        /*FutureBuilder<List<MolecularFamily>>(
          future: molecularFamilyList,
          builder:(context, snapshot) {
            if (snapshot.hasData) {
              return DropdownButton(// value: _selectedMolecularFamily,
                onChanged: (newValue) {
                  setState(() {
                    _selectedMolecularFamily = newValue;
                  });
                },
                items: molecularFamilyList.map((location) {
                  return DropdownMenuItem(
                    child: new Text(location), value: location,);
                }).toList(),
              )
            ;
            }
            else {
              return DropdownButton();
            }
          }

        )],*/



        FutureBuilder<List<MolecularFamily>>(
        future: refreshMolecularFamilyList() ,
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Text(snapshot.error);
          if (snapshot.hasData) {
            return DropdownButtonFormField(
            decoration: new InputDecoration(icon: Icon(Icons.ac_unit)),
        //, color: Colors.white10
        value: snapshot.data.first!=null ? snapshot.data.first:'',//dropDownList[0],//getSelectedMolecularFamilyID(molecularAllergene==null?0:molecularAllergene.molecular_family_id, snapshot.data),

        items: snapshot.data.map((MolecularFamily molecularFamily) {
          print(molecularFamily.name);
            return DropdownMenuItem<MolecularFamily>(child: Text(molecularFamily.name), value: molecularFamily);
            }).toList(),

        //dropDownList.map((location) { return DropdownMenuItem(child: new Text(location), value: location,);}).toList(),

        onChanged: (newValue) {
        //setState(() => selectedCountry = newValue);
        // selectedCountry = newValue;
        //print(newValue.id);
        //print(newValue.name);
        },

        );

          }
          return DropdownButtonFormField();//CircularProgressIndicator();
        })




        ],),),

      actions: <Widget>[
        MaterialButton(elevation: 5.0,child: Text('Confirm'), onPressed: () async {
          if (_formKey.currentState.validate()) {
            MolecularAllergene tempAllergene = MolecularAllergene(molecularAllergene==null?0:molecularAllergene.id,
                molecularAllergeneNameController.text, 0 /** Molecular family ID **/,
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




  int getSelectedMolecularFamilyID(int molecular_family_id, List<MolecularFamily> molecularFamilyList){
    for(int i = 0;i<molecularFamilyList.length;i++){
      if ( molecular_family_id == molecularFamilyList[i].id)
        return i;
    }
    return 0;
    }


  Future<List<MolecularFamily>> refreshMolecularFamilyList() async {
    setState(() {molecularFamilyList = dbHelper.getMolecularFamilies();});
    return molecularFamilyList;
  }
}