import 'package:allergensapp/Beings/Conclusion.dart';
import 'package:allergensapp/Tools/UiTools.dart';
import 'package:flutter/material.dart';


class ConclusionDialog extends StatelessWidget {

  Future<Conclusion> conclusionObj;
  ConclusionDialog(this.conclusionObj);
  TextStyle mediumTextStyle = TextStyle(fontSize: 15.0, color: Colors.blueAccent,fontWeight: FontWeight.bold);
  TextStyle bigTextStyle = TextStyle(fontSize: 15.0, color: Colors.grey[600], fontWeight: FontWeight.normal);

  @override
  Widget build(BuildContext context) {

    final String title = 'Détails';

    final String unknownText = 'inconnu';
    final String pollenLabel = 'Polen : ';
    final String pollenCrossGroupLabel = 'Polen / Allergies croisées : ';
    final String alimentLabel = 'Aliment : ';
    final String alimentCrossGroupLabel = 'Aliment / Allergies croisées : ';
    final String molecularFamilyLabel = 'Famille moléculaire : ';
    final String molecularFamilyOccurrenceFrequencyLabel = "Fréquence d'occurrence de la famille moléculaire : ";
    final String molecularAllergenLabel = 'Allergène Moléculaire : ';
    final String reactionLevelLabel = 'Niveau de réaction : ';
    final String adaptedTreatmentLabel = 'Traitement adapté : ';


    return Center(child:
        Stack(children: <Widget>[


          ListView(shrinkWrap: true, children:[


            AlertDialog(title: Row(children: <Widget>[
              Expanded(child: Text(title),),
              Container(child:
              FloatingActionButton(backgroundColor: Colors.white,elevation: 0.0,child: Icon(Icons.clear,color: Colors.grey,),
                onPressed: (){Navigator.of(context).pop(false);},
              )
              ),

            ],),
              content: FutureBuilder<Conclusion>(
                  future: conclusionObj,
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                      return Column(crossAxisAlignment: CrossAxisAlignment.start,children: <Widget>[

                      RichText(
                      text: TextSpan(
                        style: mediumTextStyle,
                        children: <TextSpan>[
                          TextSpan(text: pollenLabel, style: bigTextStyle), TextSpan(text: '${snapshot.data.source1}\n'),
                          TextSpan(text: pollenCrossGroupLabel, style: bigTextStyle), TextSpan(text: '${snapshot.data.source1CrossGroup}\n'),
                          TextSpan(text: alimentLabel, style: bigTextStyle), TextSpan(text: '${snapshot.data.source2}\n'),
                          //TextSpan(text: alimentCrossGroupLabel, style: bigTextStyle), TextSpan(text: '${snapshot.data.source2CrossGroup}\n'),
                          TextSpan(text: molecularFamilyLabel, style: bigTextStyle), TextSpan(text: '${snapshot.data.molecularFamily}\n'),
                          TextSpan(text: molecularFamilyOccurrenceFrequencyLabel, style: bigTextStyle), TextSpan(text: '${snapshot.data.occurrenceFrequency==-1?unknownText:snapshot.data.occurrenceFrequency}%\n'),
                          TextSpan(text: molecularAllergenLabel, style: bigTextStyle), TextSpan(text: '${snapshot.data.molecularAllergen}\n'),
                          TextSpan(text: reactionLevelLabel, style: bigTextStyle), TextSpan(text: '${UiTools.getReactionByLvl(snapshot.data.reactionLvl)}\n'),
                          TextSpan(text: adaptedTreatmentLabel, style: bigTextStyle), TextSpan(text: '${snapshot.data.adaptedTreatment}\n'),
                        ],),),

                        SizedBox(height: 50,),
                      ],);
                    } else
                      return Container();
                  }),


            ),
          ],),






        ],)

    );
  }
}