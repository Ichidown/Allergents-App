import 'package:allergensapp/Beings/MolecularAllergen.dart';

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
  Future<List<Allergen>> allergenList;
  Future<List<MolecularFamily>> molecularFamilyList;
  //Future<List<MolecularAllergen>> molecularAllergenList;
  //List<MolecularAllergen> molecularAllergenListP;

  TextEditingController occurrenceFrequencyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  GlobalKey molecularFamilyChooserKey = new GlobalKey();

  MFamilyAllergen mFamilyAllergene;
  _MolecularFamilyToAllergeneDialogState(this.mFamilyAllergene, this.allergenList, this.molecularFamilyList);

  Allergen _selectedAllergen_1,_selectedAllergen_2;
  MolecularFamily _selectedMolecularFamily;

  final dbHelper = DatabaseHelper.instance;


  final String dialogEditTitle = 'Modifier le lien Famille moléculaire / Allergène';
  final String dialogInsertTitle = 'Nouveau lien famille moléculaire / allergènes';
  final String confirmBtnText = 'Confirmer';
  final String cancelBtnText = 'Annuler';

  final String validatorText1 = "Veiullez créer d'abord un allergène";
  final String validatorText2 = "Veiullez créer d'abord une famille moléculaire";
  final String textFieldLabel = "Fréquence d'occurrence";

  List<bool> selectedMolecularAllergenList;
  //List<int> selectedMolecularAllergenIdList = []; /** Not filled right **/
  //List<int> molecularAllergenIdList = [];

  bool shouldUpdateCheckList = true;


  @override
  void initState() {

    //initSelectedMolecularAllergenList();

    if(mFamilyAllergene != null){
      occurrenceFrequencyController.text = mFamilyAllergene.occurrenceFrequency.toString();
      //molecularAllergenList = dbHelper.getMolecularAllergensFromMFamily(mFamilyAllergene.id);
      //refreshRelatedMolecularAllergenList(mFamilyAllergene.molecularFamilyID);
    }
    else{
      occurrenceFrequencyController.text = '';
      /*molecularFamilyList.then((onValue){
        if(onValue.length>0)
          refreshRelatedMolecularAllergenList(onValue[0].id);
      });*/
    }

    //molecularAllergenListP = await molecularAllergenList;


    super.initState();
  }

  @override
  Widget build(BuildContext context) {




    return Stack(children: <Widget>[

    Center(child: ListView(shrinkWrap: true, children:[
      AlertDialog(title: Text(mFamilyAllergene != null? dialogEditTitle : dialogInsertTitle),
        content:Form( key: _formKey,
          child: Column(children: <Widget>[


            FutureBuilder<List<Allergen>>(
                future: allergenList,//refreshMolecularFamilyList(),
                builder: (context, snapshot) {
                  //if (snapshot.hasError) return Text(snapshot.error);
                  if (snapshot.hasData) {
                    initCurrentSelectedAllergene_1(mFamilyAllergene, snapshot.data);
                    return DropdownButtonFormField(decoration: new InputDecoration(icon: Icon(Icons.looks_one)),
                      onChanged: (newValue) {setState(() {_selectedAllergen_1 = newValue;});},
                      value: _selectedAllergen_1,//initCurrentSelectedMolecularFamily(molecularAllergene, snapshot.data),
                      items: snapshot.data.map((Allergen molecularAllergene) {
                        return DropdownMenuItem<Allergen>(child: Text(molecularAllergene.name), value:molecularAllergene);
                      }).toList(),
                      validator: (value) { if (value == null) { return validatorText1;} return null;},
                    );
                  }
                  return DropdownButtonFormField(items: null, onChanged: (newValue){},); //CircularProgressIndicator();
                }),



            FutureBuilder<List<Allergen>>(
                future: allergenList,//refreshMolecularFamilyList(),
                builder: (context, snapshot) {
                  //if (snapshot.hasError) return Text(snapshot.error);
                  if (snapshot.hasData) {
                    initCurrentSelectedAllergene_2(mFamilyAllergene, snapshot.data);
                    return DropdownButtonFormField(decoration: new InputDecoration(icon: Icon(Icons.looks_two)),
                      onChanged: (newValue) {setState(() {_selectedAllergen_2 = newValue;});},
                      value: _selectedAllergen_2,//initCurrentSelectedMolecularFamily(molecularAllergene, snapshot.data),
                      items: snapshot.data.map((Allergen molecularAllergene) {
                        return DropdownMenuItem<Allergen>(child: Text(molecularAllergene.name), value:molecularAllergene);
                      }).toList(),
                      validator: (value) { if (value == null) { return validatorText1;} return null;},
                    );
                  }
                  return DropdownButtonFormField(items: null, onChanged: (newValue){},); //CircularProgressIndicator();
                }),




            FutureBuilder<List<MolecularFamily>>(
                future: molecularFamilyList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    initCurrentSelectedMolecularFamily(mFamilyAllergene, snapshot.data);
                    return DropdownButtonFormField(isExpanded: true,decoration: InputDecoration(icon: Icon(Icons.category)),
                      key: molecularFamilyChooserKey,
                      onChanged: (newValue) {setState(() {
                        setState(() {
                          _selectedMolecularFamily = newValue;
                          //molecularAllergenList = dbHelper.getMolecularAllergensFromMFamily(_selectedMolecularFamily.id);
                          //refreshRelatedMolecularAllergenList(_selectedMolecularFamily.id);
                          shouldUpdateCheckList = true;

                        });
                      });},
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

/**

            Container( constraints: BoxConstraints( maxHeight: 200,minHeight: 100),
              margin: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey)
              ),

              child:

              FutureBuilder<List<MolecularAllergen>>(
                  future: molecularAllergenList,
                  builder: (context, snapshot){
                    if(snapshot.hasData){

                      if(shouldUpdateCheckList){
                        updateCheckList(snapshot.data);
                        shouldUpdateCheckList = false;
                      }

                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index){
                            return CheckboxListTile(
                                value: selectedMolecularAllergenList[index],
                                title: Text(snapshot.data[index].name),
                                controlAffinity: ListTileControlAffinity.leading,
                                onChanged:(bool val){
                                  setState(() {
                                    selectedMolecularAllergenList[index] = !selectedMolecularAllergenList[index];
                                  });
                                }
                            );
                          });

                    } else {
                      // selectedMolecularAllergenList = [];
                      return Container();
                    }
                  }
              )
              ,

            ),

*/




          ],),),

        actions: <Widget>[
          MaterialButton(elevation: 5.0,child: Text(confirmBtnText), onPressed: () async {
            if (_formKey.currentState.validate()) {
              MFamilyAllergen tempMFamilyAllergene = MFamilyAllergen(
                  mFamilyAllergene==null?0:mFamilyAllergene.id,
                  _selectedAllergen_1.id,
                  _selectedAllergen_2.id,
                  _selectedMolecularFamily.id,
                  occurrenceFrequencyController.text==''?-1:int.parse(occurrenceFrequencyController.text));
              Navigator.of(context).pop(tempMFamilyAllergene/**{0:tempMFamilyAllergene,1:null/**getSelectedMolecularAllergenIdList()*/,2:selectedMolecularAllergenList}*/);
            }
          },),

          MaterialButton(elevation: 5.0,child: Text(cancelBtnText), onPressed: (){
            Navigator.of(context).pop(null);//'0');// 0 = canceled && null/2 = error
          },),
        ],

      ),
    ],),)
    ],);

  }


  void initCurrentSelectedAllergene_1(MFamilyAllergen mFamilyAllergene, List<Allergen> allergeneList) {
    if(_selectedAllergen_1 == null){
      if (mFamilyAllergene != null) // is edit
        _selectedAllergen_1 = getSelectedAllergenFromID(mFamilyAllergene.allergenID1,allergeneList);
      else  // is new
        _selectedAllergen_1 = allergeneList.length>0?allergeneList.first:null;
    }
  }


  void initCurrentSelectedAllergene_2(MFamilyAllergen mAllergeneReaction, List<Allergen> allergeneList) {
    if(_selectedAllergen_2 == null){
      if (mAllergeneReaction != null) // is edit
        _selectedAllergen_2 = getSelectedAllergenFromID(mAllergeneReaction.allergenID2,allergeneList);
      else  // is new
        _selectedAllergen_2 = allergeneList.length>0?allergeneList.first:null;
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


  Allergen getSelectedAllergenFromID(int molecularAllergeneId, List<Allergen> molecularAllergeneList){
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


  /*void refreshRelatedMolecularAllergenList(int mFamilyId){
    setState(() {
      molecularAllergenList = dbHelper.getMolecularAllergensFromMFamily(mFamilyId);
    });*/

    /**molecularAllergenList.then((onValue){
      selectedMolecularAllergenList = [];
      onValue.forEach((mA){
        //print(mA.name);
        setState(() {
          dbHelper.getSource1Source2MfMaLink(mFamilyAllergene.molecularFamilyID,mA.id).then((onValue){
            selectedMolecularAllergenList.add(onValue);
          });
        });

      });
    });*/


    /**dbHelper.getMolecularAllergensFromMFamily(mFamilyAllergenId).then((onValue){
      onValue.forEach((mAllergen){
        selectedMolecularAllergenList = [];
        dbHelper.getSource1Source2MfMaLink(mFamilyAllergene.molecularFamilyID,mAllergen.id).then((onValue){
          // print(onValue);
          selectedMolecularAllergenList.add(onValue);
        });
      });
    });*/
  //}


  /**List<int> getSelectedMolecularAllergenIdList(){
    List<int> idList = [];
    for(int i =0; i<;i++){

    }

    selectedMolecularAllergenList.forEach((isSelected){
      if(isSelected) idList.add();
    });
  }*/


  /**void initSelectedMolecularAllergenList() async{
    /**var val = await theFuture;
    print(val);*/

    //molecularAllergenListP = await
    molecularAllergenList.then((mAL){
      dbHelper.getSource1Source2MfMaLink(mFamilyAllergene.molecularFamilyID,mAL).then((onValue) {
        setState(() {
          selectedMolecularAllergenList = onValue;
          //print(onValue);
        });
      });
    });


  }*/


  /**void updateCheckList(List<MolecularAllergen> molecularAllergenList){
    dbHelper.getSource1Source2MfMaLink(mFamilyAllergene.molecularFamilyID,molecularAllergenList).then((onValue){
      setState(() {
        selectedMolecularAllergenList = onValue;
      });
    });
  }*/

}