import 'package:flutter/material.dart';


class DeleteDialog extends StatelessWidget {
  String messageText;
  DeleteDialog(this.messageText);

  @override
  Widget build(BuildContext context) {

    return Center(child: ListView(shrinkWrap: true, children:[
    AlertDialog(title: Text('Confirm Delete'),
      content:Column(children: <Widget>[
        Text(messageText),
      ],),
      actions: <Widget>[
        MaterialButton(elevation: 5.0,child: Text('Confirm',style: TextStyle(color: Colors.redAccent)), onPressed: () async {
          Navigator.of(context).pop(true);// confirm
        },),

        MaterialButton(elevation: 5.0,child: Text('Cancel',style: TextStyle(color: Colors.black),), onPressed: (){
          Navigator.of(context).pop(false);// canceled
        },),

      ],
    ),
    ],),);
  }
}