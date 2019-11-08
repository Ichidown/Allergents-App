import 'dart:convert';

class Food {
  int id;
  String name;
  String allergeneId;

  Food(this.id, this.name, this.allergeneId);


  Food foodFromJson(String str) {
    final jsonData = json.decode(str);
    return Food.fromJson(jsonData);
  }

  factory Food.fromJson(Map<String, dynamic> json){
    return new Food(json["id"],json["name"],json["Allergene_id"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'Allergene_id': allergeneId,
    };
  }

  Map<String, dynamic> toJsonNoId() {
    return {
      'name': name,
      'Allergene_id': allergeneId,
    };
  }
}