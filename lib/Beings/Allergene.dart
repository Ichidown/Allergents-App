
import 'dart:convert';
import 'dart:typed_data';

class Allergene {
  int id;
  String name;
  int allergeneType;
  String color;
  String crossGroup;
  Uint8List image;

  Allergene(this.id, this.name, this.allergeneType,this.color,this.crossGroup, this.image);


  Allergene allergeneFromJson(String str) {
    final jsonData = json.decode(str);
    return Allergene.fromJson(jsonData);
  }

  factory Allergene.fromJson(Map<String, dynamic> json){
    return new Allergene(json["id"],json["name"],json["Allergene_type"],json["color"],json["cross_group"],json["image"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'Allergene_type': allergeneType,
      'color':color,
      'cross_group':crossGroup,
      'image':image,
    };
  }

  Map<String, dynamic> toJsonNoId() {
    return {
      'name': name,
      'Allergene_type': allergeneType,
      'color':color,
      'cross_group':crossGroup,
      'image':image,
    };
  }
}