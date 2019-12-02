import 'dart:io';
import 'dart:typed_data';

import 'package:allergensapp/Tools/GeneralTools.dart';

import '../../Beings/Allergene.dart';
import '../../Tools/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:simple_permissions/simple_permissions.dart';


class AllergeneDialog extends StatefulWidget {
  Allergene allergene;
  AllergeneDialog(this.allergene);

  @override
  _AllergeneDialogState createState() => _AllergeneDialogState(allergene);

}

class _AllergeneDialogState extends State<AllergeneDialog> {
  Allergene allergene;
  _AllergeneDialogState(this.allergene);
  ImageProvider _image;
  Uint8List _imageBytes;

  final dbHelper = DatabaseHelper.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController allergeneNameController = TextEditingController();
  TextEditingController allergeneCrossGroupController = TextEditingController();
  static List<String> _typeList = ['Pollens', 'Aliments']; // Option 2
  String dialogTitle,_selectedType;
  ImageProvider noImage = AssetImage('assets/images/NewImage.png');


  @override
  Widget initState(){
    if(allergene != null){
      dialogTitle = 'Edit Allergene';
      allergeneNameController.text = allergene.name;
      allergeneCrossGroupController.text = allergene.crossGroup;
      _selectedType = _typeList[allergene.allergeneType];
      _image = allergene.image!=null?MemoryImage(allergene.image):AssetImage('assets/images/NewImage.png');
    } else{
      dialogTitle = 'New Allergene';
      allergeneNameController.text = '';
      allergeneCrossGroupController.text = '';
      _selectedType = _typeList.first;
      _image = noImage;
    }
    super.initState();
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

            TextFormField(controller:allergeneCrossGroupController, decoration: InputDecoration(labelText: 'Allergene Cross Group',)),

            //Tooltip(message: 'Pick an Image',child:
            GestureDetector(child: SizedBox(width: 200,height: 150,child:
            /*Image(image: _image,)*/
            Container( margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: _image,
                  fit: BoxFit.cover,
                )

              ))
              ,),
              onTap: (){
              pickImage();
              },)
            //),




          ],),),

        actions: <Widget>[
          MaterialButton(elevation: 5.0,child: Text('Confirm'), onPressed: () async {
            if (_formKey.currentState.validate()) {
              Allergene tempAllergene = allergene==null?
              // Create
              Allergene(0,
                  allergeneNameController.text,_typeList.indexOf(_selectedType),
                  GeneralTools.getRandomColor(), allergeneCrossGroupController.text,
                  _imageBytes):
              // Edit
              Allergene(allergene.id,
                  allergeneNameController.text,_typeList.indexOf(_selectedType),
                  allergene.color, allergeneCrossGroupController.text,
                  _imageBytes==null?allergene.image:_imageBytes);

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


  Future pickImage() async {

    //PermissionStatus permissionResult = await SimplePermissions.requestPermission(Permission. WriteExternalStorage);
    //if (permissionResult == PermissionStatus.authorized){
      File image = await ImagePicker.pickImage(source: ImageSource.gallery);

      if (image!=null){
        _imageBytes = GeneralTools.dataFromBase64String(GeneralTools.base64String(image.readAsBytesSync()));
        setState(() {
          _image = FileImage(image);
        });
      }
    //}



  }

}