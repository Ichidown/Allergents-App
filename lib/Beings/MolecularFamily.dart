
import 'dart:convert';

class MolecularFamily {
  int id;
  String name;
  String color;
  int occurrenceFrequency;

  MolecularFamily(this.id, this.name, this.color, this.occurrenceFrequency);


  MolecularFamily molecularFamilyFromJson(String str) {
    final jsonData = json.decode(str);
    return MolecularFamily.fromJson(jsonData);
  }

  factory MolecularFamily.fromJson(Map<String, dynamic> json){
    return new MolecularFamily(json["id"],json["name"],json["color"],json["occurrence_frequency"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color':color,
      //'occurrence_frequency':occurrenceFrequency,
    };
  }

  Map<String, dynamic> toJsonNoId() {
    return {
      'name': name,
      'color':color,
      //'occurrence_frequency':occurrenceFrequency,
    };
  }
}