
import 'dart:convert';

class MolecularAllergene {
  int id;
  String name;
  int molecular_family_id;
  String color;

  MolecularAllergene(this.id, this.name, this.molecular_family_id, this.color);


  MolecularAllergene molecularAllergeneFromJson(String str) {
    final jsonData = json.decode(str);
    return MolecularAllergene.fromJson(jsonData);
  }

  factory MolecularAllergene.fromJson(Map<String, dynamic> json){
    return new MolecularAllergene(json["id"],json["name"],json["molecular_family_id"],json["color"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'molecular_family_id' : molecular_family_id,
      'color':color,
    };
  }

  Map<String, dynamic> toJsonNoId() {
    return {
      'name': name,
      'molecular_family_id' : molecular_family_id,
      'color':color,
    };
  }
}