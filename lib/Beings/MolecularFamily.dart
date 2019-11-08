
import 'dart:convert';

class MolecularFamily {
  int id;
  String name;
  String color;

  MolecularFamily(this.id, this.name, this.color);


  MolecularFamily molecularFamilyFromJson(String str) {
    final jsonData = json.decode(str);
    return MolecularFamily.fromJson(jsonData);
  }

  factory MolecularFamily.fromJson(Map<String, dynamic> json){
    return new MolecularFamily(json["id"],json["name"],json["color"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color':color,
    };
  }

  Map<String, dynamic> toJsonNoId() {
    return {
      'name': name,
      'color':color,
    };
  }
}