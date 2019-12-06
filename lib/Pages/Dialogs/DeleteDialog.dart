import 'package:flutter/material.dart';


class DeleteDialog extends StatelessWidget {
  String messageText;
  DeleteDialog(this.messageText);

  @override
  Widget build(BuildContext context) {


    final String title = 'Confirmer la suppression';
    final String confirmText = 'Confirmer';
    final String cancelText = 'Annuler';

    return Center(child: ListView(shrinkWrap: true, children:[
      AlertDialog(title: Text(title),
        content:Column(children: <Widget>[
          Text(messageText),
        ],),
        actions: <Widget>[
          MaterialButton(elevation: 5.0,child: Text(confirmText,style: TextStyle(color: Colors.redAccent)), onPressed: () async {
            Navigator.of(context).pop(true);// confirm
          },),

          MaterialButton(elevation: 5.0,child: Text(cancelText,style: TextStyle(color: Colors.black),), onPressed: (){
            Navigator.of(context).pop(false);// canceled
          },),

        ],
      ),
    ],),);
  }
}