import 'dart:convert';

class Reaction {
  int id;
  int level;
  String adapted_treatment;

  Reaction(this.id, this.level, this.adapted_treatment);


  Reaction reactionFromJson(String str) {
    final jsonData = json.decode(str);
    return Reaction.fromJson(jsonData);
  }

  factory Reaction.fromJson(Map<String, dynamic> json){
    return new Reaction(json["id"],json["level"],json["adapted_treatment"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'level': level,
      'adapted_treatment': adapted_treatment,
    };
  }

  Map<String, dynamic> toJsonNoId() {
    return {
      'level': level,
      'adapted_treatment': adapted_treatment,
    };
  }
}