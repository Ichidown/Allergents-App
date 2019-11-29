import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_colorpicker/material_picker.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';


class ColorPickerDialog extends StatefulWidget {


  @override
  _ColorPickerDialogState createState() =>
      _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {


  @override
  Widget build(BuildContext context) {
    return

      Container(
        alignment: Alignment.center,
          child: AlertDialog(
              title: Text('Pick a color'),
              content:


              /**ColorPicker(
                pickerColor: Colors.redAccent,
                //onColorChanged: changeColor,
                enableLabel: true,
                pickerAreaHeightPercent: 0.8,
              ),*/
            // Use Material color picker:
            //
            MaterialPicker(
               pickerColor: Colors.redAccent,
               onColorChanged: (Color color) {
                  Navigator.of(context).pop(color.toHex());
                 //print(color.toString());
                 },
               enableLabel: true, // only on portrait mode
             ),
            //
            // Use Block color picker:
            //
            // child: BlockPicker(
            //   pickerColor: currentColor,
            //   onColorChanged: changeColor,
            // ),
          ),
        /*actions: <Widget>[
          FlatButton(
            child: const Text('Got it'),
            onPressed: () {
              setState(() => currentColor = pickerColor);
              Navigator.of(context).pop();
            },
          ),
        ],*/
      //)

              /**MaterialColorPicker( shrinkWrap: true, onlyShadeSelection: true,
                  onColorChange: (Color color) {
                Navigator.of(context).pop(color.toHex());},
                  )*/

        //  ),
        );
  }
}




extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '0x' : ''}'
      '${alpha.toRadixString(16)}'
      '${red.toRadixString(16)}'
      '${green.toRadixString(16)}'
      '${blue.toRadixString(16)}';
}
