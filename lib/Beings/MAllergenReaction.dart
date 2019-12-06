
import 'dart:convert';

class MAllergenReaction {
  int id;
  int molecularAllergenID;
  int reactionID;


  MAllergenReaction(this.id, this.molecularAllergenID,this.reactionID);

  MAllergenReaction mAllergenReactionJson(String str) {
    final jsonData = json.decode(str);
    return MAllergenReaction.fromJson(jsonData);
  }

  factory MAllergenReaction.fromJson(Map<String, dynamic> json){
    return new MAllergenReaction(json["id"],json["molecular_Allergene_id"],json["reaction_id"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'molecular_Allergene_id': molecularAllergenID,
      'reaction_id': reactionID,
    };
  }

  Map<String, dynamic> toJsonNoId() {
    return {
      'molecular_Allergene_id': molecularAllergenID,
      'reaction_id': reactionID,
    };
  }
}