import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class AllergeneColorPickerDialog extends StatefulWidget {


  @override
  _AllergeneColorPickerDialogState createState() =>
      _AllergeneColorPickerDialogState();
}

class _AllergeneColorPickerDialogState extends State<AllergeneColorPickerDialog> {


  @override
  Widget build(BuildContext context) {
    return

      Container(
        alignment: Alignment.center,
          child: AlertDialog(
              title: Text('Pick a color'),
              content: MaterialColorPicker( shrinkWrap: true, onlyShadeSelection: true,
                  onColorChange: (Color color) {
                Navigator.of(context).pop(color.toHex());},
                  )),
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
