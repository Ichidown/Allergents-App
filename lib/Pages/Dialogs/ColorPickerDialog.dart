import 'package:allergensapp/Tools/GeneralTools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/material_picker.dart';


class ColorPickerDialog extends StatefulWidget {
  @override
  _ColorPickerDialogState createState() =>
      _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {

  final String title = 'Choisis une couleur';

  @override
  Widget build(BuildContext context) {
    return

      Container(
        alignment: Alignment.center,
          child: AlertDialog(
              title: Text(title),
              content:
              MaterialPicker(pickerColor: Colors.redAccent,
               onColorChanged: (Color color) {
                  Navigator.of(context).pop(GeneralTools.toHex(color));
                 },
               enableLabel: true, // only on portrait mode
             ),
          ),
        );
  }
}