import '../../Beings/Allergen.dart';
import '../../Beings/MFamilyAllergen.dart';
import '../../Beings/MolecularFamily.dart';
import '../../Tools/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class MolecularFamilyToAllergeneDialog extends StatefulWidget {
  Future<List<Allergen>> allergeneList;
  Future<List<MolecularFamily>> molecularFamilyList;
  MFamilyAllergen mFamilyAllergene;

  MolecularFamilyToAllergeneDialog(this.mFamilyAllergene, this.allergeneList, this.molecularFamilyList);

  @override
  _MolecularFamilyToAllergeneDialogState createState() => _MolecularFamilyToAllergeneDialogState(mFamilyAllergene,allergeneList,molecularFamilyList);

}

class _MolecularFamilyToAllergeneDialogState extends State<MolecularFamilyToAllergeneDialog> {
  Future<List<Allergen>> allergeneList;
  Future<List<MolecularFamily>> molecularFamilyList;
  TextEditingController occurrenceFrequencyController = TextEditingController();

  MFamilyAllergen mFamilyAllergene;
  _MolecularFamilyToAllergeneDialogState(this.mFamilyAllergene, this.allergeneList, this.molecularFamilyList);
  final _formKey = GlobalKey<FormState>();
  Allergen _selectedAllergene_1,_selectedAllergene_2;
  MolecularFamily _selectedMolecularFamily;
  final dbHelper = DatabaseHelper.instance;


  final String dialogEditTitle = 'Modifier le lien Famille moléculaire / Allergène';
  final String dialogInsertTitle = 'Nouveau lien famille moléculaire / allergènes';
  final String confirmBtnText = 'Confirmer';
  final String cancelBtnText = 'Annuler';

  final String validatorText1 = "Veiullez créer d'abord un allergène";
  final String validatorText2 = "Veiullez créer d'abord une famille moléculaire";
  final String textFieldLabel = "Fréquence d'occurrence";


  @override
  void initState() {
    if(mFamilyAllergene != null)
      occurrenceFrequencyController.text = mFamilyAllergene.occurrenceFrequency.toString();
    else
      occurrenceFrequencyController.text = '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: ListView(shrinkWrap: true, children:[
    AlertDialog(title: Text(mFamilyAllergene != null? dialogEditTitle : dialogInsertTitle),
      content:Form( key: _formKey,
        child: Column(children: <Widget>[


          FutureBuilder<List<Allergen>>(
              future: allergeneList,//refreshMolecularFamilyList(),
              builder: (context, snapshot) {
                //if (snapshot.hasError) return Text(snapshot.error);
                if (snapshot.hasData) {
                  initCurrentSelectedAllergene_1(mFamilyAllergene, snapshot.data);
                  return DropdownButtonFormField(decoration: new InputDecoration(icon: Icon(Icons.looks_one)),
                    onChanged: (newValue) {setState(() {_selectedAllergene_1 = newValue;});},
                    value: _selectedAllergene_1,//initCurrentSelectedMolecularFamily(molecularAllergene, snapshot.data),
                    items: snapshot.data.map((Allergen molecularAllergene) {
                      return DropdownMenuItem<Allergen>(child: Text(molecularAllergene.name), value:molecularAllergene);
                    }).toList(),
                    validator: (value) { if (value == null) { return validatorText1;} return null;},
                  );
                }
                return DropdownButtonFormField(items: null, onChanged: (newValue){},); //CircularProgressIndicator();
              }),



          FutureBuilder<List<Allergen>>(
              future: allergeneList,//refreshMolecularFamilyList(),
              builder: (context, snapshot) {
                //if (snapshot.hasError) return Text(snapshot.error);
                if (snapshot.hasData) {
                  initCurrentSelectedAllergene_2(mFamilyAllergene, snapshot.data);
                  return DropdownButtonFormField(decoration: new InputDecoration(icon: Icon(Icons.looks_two)),
                    onChanged: (newValue) {setState(() {_selectedAllergene_2 = newValue;});},
                    value: _selectedAllergene_2,//initCurrentSelectedMolecularFamily(molecularAllergene, snapshot.data),
                    items: snapshot.data.map((Allergen molecularAllergene) {
                      return DropdownMenuItem<Allergen>(child: Text(molecularAllergene.name), value:molecularAllergene);
                    }).toList(),
                    validator: (value) { if (value == null) { return validatorText1;} return null;},
                  );
                }
                return DropdownButtonFormField(items: null, onChanged: (newValue){},); //CircularProgressIndicator();
              }),




          FutureBuilder<List<MolecularFamily>>(
              future: molecularFamilyList,//refreshMolecularFamilyList(),
              builder: (context, snapshot) {
                //if (snapshot.hasError) return Text(snapshot.error);
                if (snapshot.hasData) {
                  initCurrentSelectedMolecularFamily(mFamilyAllergene, snapshot.data);
                  return DropdownButtonFormField(decoration: new InputDecoration(icon: Icon(Icons.category)),
                    onChanged: (newValue) {setState(() {_selectedMolecularFamily = newValue;});},
                    value: _selectedMolecularFamily,//initCurrentSelectedMolecularFamily(molecularAllergene, snapshot.data),
                    items: snapshot.data.map((MolecularFamily reaction) {
                      return DropdownMenuItem<MolecularFamily>(child: Text(reaction.name), value:reaction);
                    }).toList(),
                    validator: (value) { if (value == null) { return validatorText2;} return null;},
                  );
                }
                return DropdownButtonFormField(items: null, onChanged: (newValue){},); //CircularProgressIndicator();
              }),



          TextFormField(controller:occurrenceFrequencyController, decoration: InputDecoration(labelText: textFieldLabel,icon: Text('%', style: TextStyle(fontSize: 20,fontWeight: FontWeight.w900,color: Colors.grey),)),
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],keyboardType: TextInputType.number),

        ],),),

      actions: <Widget>[
        MaterialButton(elevation: 5.0,child: Text(confirmBtnText), onPressed: () async {
          if (_formKey.currentState.validate()) {
            MFamilyAllergen tempMFamilyAllergene = MFamilyAllergen(
                mFamilyAllergene==null?0:mFamilyAllergene.id,
                _selectedAllergene_1.id,
                _selectedAllergene_2.id,
                _selectedMolecularFamily.id,
                occurrenceFrequencyController.text==''?-1:int.parse(occurrenceFrequencyController.text));
            Navigator.of(context).pop(tempMFamilyAllergene);
          }
        },),

        MaterialButton(elevation: 5.0,child: Text(cancelBtnText), onPressed: (){
          Navigator.of(context).pop(null);//'0');// 0 = canceled && null/2 = error
        },),
      ],

    ),
    ],),);
  }


  void initCurrentSelectedAllergene_1(MFamilyAllergen mFamilyAllergene, List<Allergen> allergeneList) {
    if(_selectedAllergene_1 == null){
      if (mFamilyAllergene != null) // is edit
        _selectedAllergene_1 = getSelectedAllergeneFromID(mFamilyAllergene.allergenID1,allergeneList);
      else  // is new
        _selectedAllergene_1 = allergeneList.length>0?allergeneList.first:null;
    }
  }


  void initCurrentSelectedAllergene_2(MFamilyAllergen mAllergeneReaction, List<Allergen> allergeneList) {
    if(_selectedAllergene_2 == null){
      if (mAllergeneReaction != null) // is edit
        _selectedAllergene_2 = getSelectedAllergeneFromID(mAllergeneReaction.allergenID2,allergeneList);
      else  // is new
        _selectedAllergene_2 = allergeneList.length>0?allergeneList.first:null;
    }
  }


  void initCurrentSelectedMolecularFamily(MFamilyAllergen mAllergeneReaction, List<MolecularFamily> reactionList) {
    if(_selectedMolecularFamily == null){
      if (mAllergeneReaction != null) // is edit
        _selectedMolecularFamily = getSelectedMolecularFamilyFromID(mAllergeneReaction.molecularFamilyID,reactionList);
      else  // is new
        _selectedMolecularFamily = reactionList.length>0?reactionList.first:null;
    }
  }


  Allergen getSelectedAllergeneFromID(int molecularAllergeneId, List<Allergen> molecularAllergeneList){
    for(int i = 0;i<molecularAllergeneList.length;i++){
      if ( molecularAllergeneId == molecularAllergeneList[i].id)
        return molecularAllergeneList[i];
    }
    return null;
  }


  MolecularFamily getSelectedMolecularFamilyFromID(int reactionId, List<MolecularFamily> mFamilyList){
    for(int i = 0;i<mFamilyList.length;i++){
      if ( reactionId == mFamilyList[i].id)
        return mFamilyList[i];
    }
    return null;
  }

}