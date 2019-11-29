import 'package:flutter/material.dart';


class ConclusionDialog extends StatelessWidget {

  ConclusionDialog();

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
              content:Column(crossAxisAlignment: CrossAxisAlignment.start,children: <Widget>[



                Text('Polen :'),
                Text('Aliment :'),
                Text('Molecular Family :'),
                Text('Reaction Level :'),
                Text('Adapted Treatment :'),

                SizedBox(height: 50,),
              ],),
            ),
          ],),






        ],)

    );
  }
}