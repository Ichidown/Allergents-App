
import 'dart:convert';

class MAllergeneReaction {
  int id;
  int molecularAllergeneID;
  int reactionID;


  MAllergeneReaction(this.id, this.molecularAllergeneID,this.reactionID);

  MAllergeneReaction mAllergeneReactionJson(String str) {
    final jsonData = json.decode(str);
    return MAllergeneReaction.fromJson(jsonData);
  }

  factory MAllergeneReaction.fromJson(Map<String, dynamic> json){
    return new MAllergeneReaction(json["id"],json["molecular_Allergene_id"],json["reaction_id"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'molecular_Allergene_id': molecularAllergeneID,
      'reaction_id': reactionID,
    };
  }

  Map<String, dynamic> toJsonNoId() {
    return {
      'molecular_Allergene_id': molecularAllergeneID,
      'reaction_id': reactionID,
    };
  }
}