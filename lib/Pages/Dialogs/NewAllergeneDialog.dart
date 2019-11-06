import 'package:allergensapp/Beings/Allergene.dart';
import 'package:allergensapp/Tools/database_helper.dart';
import 'package:flutter/material.dart';


class NewAllergeneDialog extends StatefulWidget {
  Allergene allergene;
  NewAllergeneDialog(this.allergene);

  @override
  _NewAllergeneDialogState createState() => _NewAllergeneDialogState(allergene);

}

class _NewAllergeneDialogState extends State<NewAllergeneDialog> {
  Allergene allergene;
  _NewAllergeneDialogState(this.allergene);

  final dbHelper = DatabaseHelper.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController allergeneNameController = TextEditingController();
  static List<String> _typeList = ['Pollens', 'Aliments']; // Option 2
  String dialogTitle,_selectedType;



  /*void initialiseDialog()async{
    setState(() {

    });
  }*/

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

    // initialiseDialog();

    return Container(margin: EdgeInsets.all(0),padding : EdgeInsets.all(0),alignment: Alignment.center, child:

    //Flex(direction: Axis.vertical,children: <Widget>[
    //GestureDetector(onTap: (){Navigator.of(context).pop('0');},child:
    SingleChildScrollView(child:
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
            Allergene tempAllergene = Allergene(allergene==null?0:allergene.id,allergeneNameController.text,_typeList.indexOf(_selectedType),'0xff8e24aa');
            int id;
            if(allergene == null)
              id = await dbHelper.insertAllergene(tempAllergene.toJsonNoId());
            else
              id = await dbHelper.updateAllergene(tempAllergene.toJson());
            if (id>0) Navigator.of(context).pop('1');// 1 = success
            else Navigator.of(context).pop('2');
          }
        },),

        MaterialButton(elevation: 5.0,child: Text('Cancel'), onPressed: (){
          Navigator.of(context).pop('0');// 0 = canceled && null/2 = error
        },),

      ],
    ),
    )
    );
  }





/*
  void onAllergeneTypeChanged(bool newValue){setState(() {
    print('huh');
    isPollens = newValue;
    typeText = isPollens ? 'Pollen' : 'Aliment';
  });}*/



  /*Future<int> _insert(String name, int type) async {
    return await dbHelper.insert(Allergene(0,name,type,'').toMapNoId()); // Return created ID
    //print('inserted row id: $id');
  }*/

}