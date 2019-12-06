
import 'dart:convert';

class MFamilyAllergen {
  int id;
  int allergenID1;
  int allergenID2;
  int molecularFamilyID;
  int occurrenceFrequency;


  MFamilyAllergen(this.id, this.allergenID1, this.allergenID2, this.molecularFamilyID,this.occurrenceFrequency);

  MFamilyAllergen mFamilyAllergenFromJson(String str) {
    final jsonData = json.decode(str);
    return MFamilyAllergen.fromJson(jsonData);
  }

  factory MFamilyAllergen.fromJson(Map<String, dynamic> json){
    return new MFamilyAllergen(json["id"],json["Allergene_1_id"],json["Allergene_2_id"],json["molecular_family_id"],json['occurrence_frequency']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Allergene_1_id': allergenID1,
      'Allergene_2_id': allergenID2,
      'molecular_family_id': molecularFamilyID,
      'occurrence_frequency':occurrenceFrequency,
    };
  }

  Map<String, dynamic> toJsonNoId() {
    return {
      'Allergene_1_id': allergenID1,
      'Allergene_2_id': allergenID2,
      'molecular_family_id': molecularFamilyID,
      'occurrence_frequency':occurrenceFrequency,
    };
  }
}