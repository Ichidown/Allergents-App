
import 'dart:convert';
import 'dart:typed_data';

class Allergen {
  int id;
  String name;
  int allergenType;
  String color;
  String crossGroup;
  Uint8List image;

  Allergen(this.id, this.name, this.allergenType,this.color,this.crossGroup, this.image);


  Allergen allergenFromJson(String str) {
    final jsonData = json.decode(str);
    return Allergen.fromJson(jsonData);
  }

  factory Allergen.fromJson(Map<String, dynamic> json){
    return new Allergen(json["id"],json["name"],json["Allergene_type"],json["color"],json["cross_group"],json["image"]/*null*/);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'Allergene_type': allergenType,
      'color':color,
      'cross_group':crossGroup,
      'image':image,
    };
  }

  Map<String, dynamic> toJsonNoId() {
    return {
      'name': name,
      'Allergene_type': allergenType,
      'color':color,
      'cross_group':crossGroup,
      'image':image,
    };
  }
}