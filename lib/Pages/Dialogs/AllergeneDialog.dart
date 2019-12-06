import 'dart:io';
import 'dart:typed_data';
import 'package:allergensapp/Tools/GeneralTools.dart';
import '../../Beings/Allergen.dart';
import '../../Tools/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class AllergeneDialog extends StatefulWidget {
  Allergen allergene;
  AllergeneDialog(this.allergene);

  @override
  _AllergeneDialogState createState() => _AllergeneDialogState(allergene);

}

class _AllergeneDialogState extends State<AllergeneDialog> {
  Allergen allergene;
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


  final String validatorText1 = "S'il vous plaît entrer quelque chose";
  final String textFieldLabel = "Nom d'allergène";
  final String textFieldLabe2 = 'Allergies croisées ';

  final String confirmBtnText = 'Confirmer';
  final String cancelBtnText = 'Annuler';

  final String dialogEditTitle = "Modifier l'allergène";
  final String dialogInsertTitle = 'Nouvel allergène';


  @override
  Widget initState(){
    if(allergene != null){
      dialogTitle = dialogEditTitle;
      allergeneNameController.text = allergene.name;
      allergeneCrossGroupController.text = allergene.crossGroup;
      _selectedType = _typeList[allergene.allergenType];
      _image = allergene.image!=null?MemoryImage(allergene.image):AssetImage('assets/images/NewImage.png');
    } else{
      dialogTitle = dialogInsertTitle;
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

            TextFormField(controller:allergeneNameController, decoration: InputDecoration(labelText: textFieldLabel,),
                validator: (value) { if (value.isEmpty) { return validatorText1;} return null;},),

            DropdownButtonFormField(value: _selectedType,decoration: new InputDecoration(icon: Icon(Icons.local_florist)),
              onChanged: (newValue) { setState(() {_selectedType = newValue;});},
              items: _typeList.map((location) { return DropdownMenuItem(child: new Text(location), value: location,);}).toList(),
            ),

            TextFormField(controller:allergeneCrossGroupController, decoration: InputDecoration(labelText: textFieldLabe2,)),

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
          MaterialButton(elevation: 5.0,child: Text(confirmBtnText), onPressed: () async {
            if (_formKey.currentState.validate()) {
              Allergen tempAllergene = allergene==null?
              // Create
              Allergen(0,
                  allergeneNameController.text,_typeList.indexOf(_selectedType),
                  GeneralTools.getRandomColor(), allergeneCrossGroupController.text,
                  _imageBytes):
              // Edit
              Allergen(allergene.id,
                  allergeneNameController.text,_typeList.indexOf(_selectedType),
                  allergene.color, allergeneCrossGroupController.text,
                  _imageBytes==null?allergene.image:_imageBytes);

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


  Future pickImage() async {
      File image = await ImagePicker.pickImage(source: ImageSource.gallery);

      if (image!=null){
        _imageBytes = GeneralTools.dataFromBase64String(GeneralTools.base64String(image.readAsBytesSync()));
        setState(() {
          _image = FileImage(image);
        });
      }

  }

}