
import 'dart:convert';

class MFamilyAllergene {
  int id;
  int allergeneID1;
  int allergeneID2;
  int molecularFamilyID;


  MFamilyAllergene(this.id, this.allergeneID1, this.allergeneID2, this.molecularFamilyID);

  MFamilyAllergene mFamilyAllergeneFromJson(String str) {
    final jsonData = json.decode(str);
    return MFamilyAllergene.fromJson(jsonData);
  }

  factory MFamilyAllergene.fromJson(Map<String, dynamic> json){
    return new MFamilyAllergene(json["id"],json["Allergene_1_id"],json["Allergene_2_id"],json["molecular_family_id"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Allergene_1_id': allergeneID1,
      'Allergene_2_id': allergeneID2,
      'molecular_family_id': molecularFamilyID,
    };
  }

  Map<String, dynamic> toJsonNoId() {
    return {
      'Allergene_1_id': allergeneID1,
      'Allergene_2_id': allergeneID2,
      'molecular_family_id': molecularFamilyID,
    };
  }
}