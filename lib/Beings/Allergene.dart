
import 'dart:convert';

class Allergene {
  int id;
  String name;
  int allergeneType;
  String color;
  // image

  Allergene(this.id, this.name, this.allergeneType,this.color);


  Allergene allergeneFromJson(String str) {
    final jsonData = json.decode(str);
    return Allergene.fromJson(jsonData);
  }

  factory Allergene.fromJson(Map<String, dynamic> json){
    return new Allergene(json["id"],json["name"],json["Allergene_type"],json["color"]);
  }

  /*factory Allergene.fromJson(Map<String, dynamic> json) => new Allergene(
    id: json["id"],
    name: json["name"],
    lastName: json["Allergene_type"],
    blocked: json["color"],
  );*/

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'Allergene_type': allergeneType,
      'color':color,
    };
  }

  Map<String, dynamic> toJsonNoId() {
    return {
      'name': name,
      'Allergene_type': allergeneType,
      'color':color,
    };
  }
}