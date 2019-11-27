import 'package:allergensapp/Beings/Allergene.dart';
import 'package:allergensapp/Tools/database_helper.dart';
import 'package:flutter/material.dart';


class AllergeneDialog extends StatefulWidget {
  Allergene allergene;
  AllergeneDialog(this.allergene);

  @override
  _AllergeneDialogState createState() => _AllergeneDialogState(allergene);

}

class _AllergeneDialogState extends State<AllergeneDialog> {
  Allergene allergene;
  _AllergeneDialogState(this.allergene);

  final dbHelper = DatabaseHelper.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController allergeneNameController = TextEditingController();
  static List<String> _typeList = ['Pollens', 'Aliments']; // Option 2
  String dialogTitle,_selectedType;


  @override
  Widget initState(){
    if(allergene != null){
      dialogTitle = 'Edit Allergene';
      allergeneNameController.text = allergene.name;
      _selectedType = _typeList[allergene.allergeneType];
    } else{
      dialogTitle = 'New Allergene';
      allergeneNameController.text = '';
      _selectedType = _typeList.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: ListView(shrinkWrap: true, children:[
      AlertDialog(title: Text(dialogTitle),
        content:Form( key: _formKey,
          child: Column(children: <Widget>[

            TextFormField(controller:allergeneNameController, decoration: InputDecoration(labelText: 'Allergene Name',),
                validator: (value) { if (value.isEmpty) { return 'Please enter some text';} return null;},),

            DropdownButton(value: _selectedType,
              onChanged: (newValue) { setState(() {_selectedType = newValue;});},
              items: _typeList.map((location) { return DropdownMenuItem(child: new Text(location), value: location,);}).toList(),
            ),

          ],),),

        actions: <Widget>[
          MaterialButton(elevation: 5.0,child: Text('Confirm'), onPressed: () async {
            if (_formKey.currentState.validate()) {
              Allergene tempAllergene = Allergene(allergene==null?0:allergene.id,
                  allergeneNameController.text,_typeList.indexOf(_selectedType),
                  allergene==null?'0xff8e24aa':allergene.color);
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