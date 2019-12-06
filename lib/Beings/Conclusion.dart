
import 'dart:convert';

class Conclusion {
  String source1;
  String source2;
  String source1CrossGroup;
  String source2CrossGroup;

  String molecularFamily;
  int occurrenceFrequency;
  String molecularAllergen;

  int reactionLvl;
  String adaptedTreatment;


  Conclusion(this.source1, this.source2, this.source1CrossGroup,
      this.source2CrossGroup, this.molecularFamily, this.occurrenceFrequency,
      this.molecularAllergen, this.reactionLvl, this.adaptedTreatment);

  Conclusion conclusionFromJson(String str) {
    final jsonData = json.decode(str);
    return Conclusion.fromJson(jsonData);
  }

  factory Conclusion.fromJson(Map<String, dynamic> json){
    return new Conclusion(json["source1"],json["source2"],json["source1CrossGroup"],
        json["source2CrossGroup"],json["molecularFamily"],json["occurrenceFrequency"],
        json["molecularAllergene"],json["reactionLvl"],json["adaptedTreatment"]);
  }

}