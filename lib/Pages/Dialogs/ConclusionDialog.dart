import 'package:allergensapp/Beings/Conclusion.dart';
import 'package:allergensapp/Tools/GeneralTools.dart';
import 'package:allergensapp/Tools/UiTools.dart';
import 'package:flutter/material.dart';


class ConclusionDialog extends StatelessWidget {

  Future<Conclusion> conclusionObj;
  ConclusionDialog(this.conclusionObj);
  TextStyle mediumTextStyle = TextStyle(fontSize: 15.0, color: Colors.blueAccent,fontWeight: FontWeight.bold);
  TextStyle bigTextStyle = TextStyle(fontSize: 15.0, color: Colors.grey[600], fontWeight: FontWeight.normal);

  @override
  Widget build(BuildContext context) {



    return Center(child:
        Stack(children: <Widget>[


          ListView(shrinkWrap: true, children:[


            AlertDialog(title: Row(children: <Widget>[
              Expanded(child: Text('Details'),),
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
                          TextSpan(text: 'Polen : ', style: bigTextStyle), TextSpan(text: '${snapshot.data.source1}\n'),
                          TextSpan(text: 'Polen cross group : ', style: bigTextStyle), TextSpan(text: '${snapshot.data.source1CrossGroup}\n'),
                          TextSpan(text: 'Aliment : ', style: bigTextStyle), TextSpan(text: '${snapshot.data.source2}\n'),
                          TextSpan(text: 'Aliment cross group : ', style: bigTextStyle), TextSpan(text: '${snapshot.data.source2CrossGroup}\n'),
                          TextSpan(text: 'Molecular Family : ', style: bigTextStyle), TextSpan(text: '${snapshot.data.molecularFamily}\n'),
                          TextSpan(text: 'Molecular Family Occurence Frequency : ', style: bigTextStyle), TextSpan(text: '${snapshot.data.occurrenceFrequency==-1?'unknown':snapshot.data.occurrenceFrequency}%\n'),
                          TextSpan(text: 'Molecular Allergen : ', style: bigTextStyle), TextSpan(text: '${snapshot.data.molecularAllergene}\n'),
                          TextSpan(text: 'Reaction Level : ', style: bigTextStyle), TextSpan(text: '${UiTools.getReactionByLvl(snapshot.data.reactionLvl)}\n'),
                          TextSpan(text: 'Adapted Treatment : ', style: bigTextStyle), TextSpan(text: '${snapshot.data.adaptedTreatment}\n'),
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