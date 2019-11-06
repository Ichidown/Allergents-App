import 'package:allergensapp/Beings/Allergene.dart';
import 'package:allergensapp/Tools/database_helper.dart';
import 'package:flutter/material.dart';


class DeleteAllergeneDialog extends StatefulWidget {

  @override
  _DeleteAllergeneDialogState createState() => _DeleteAllergeneDialogState();
}

class _DeleteAllergeneDialogState extends State<DeleteAllergeneDialog> {
  final dbHelper = DatabaseHelper.instance;
  TextEditingController allergeneNameController = TextEditingController();
  static List<String> _typeList = ['Pollens', 'Aliments']; // Option 2
  String _selectedType = _typeList.first;

  String typeText = 'Pollen';
  bool isPollens = true;
  bool isSort = true;


  @override
  Widget build(BuildContext context) {


    return Container(margin: EdgeInsets.all(0),padding : EdgeInsets.all(0),alignment: Alignment.center, child:

    //Flex(direction: Axis.vertical,children: <Widget>[
    //GestureDetector(onTap: (){Navigator.of(context).pop('0');},child:
    SingleChildScrollView(child:
    AlertDialog(title: Text('Confirm Delete'),
      content:Form(
        child: Text('Are you sure you want to deleate this allergene ?'),
      ),

      actions: <Widget>[
        MaterialButton(elevation: 5.0,child: Text('Confirm',style: TextStyle(color: Colors.redAccent)), onPressed: () async {
          Navigator.of(context).pop(true);// confirm
        },),

        MaterialButton(elevation: 5.0,child: Text('Cancel',style: TextStyle(color: Colors.black),), onPressed: (){
          Navigator.of(context).pop(false);// canceled
        },),

      ],
    ),
    )
    );
  }


}