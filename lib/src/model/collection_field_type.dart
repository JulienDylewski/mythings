import 'package:flutter/cupertino.dart';
import 'package:my_things/src/common/common.dart';
import 'package:my_things/src/model/item_field.dart';

abstract class CollectionFieldType
{
  CollectionFieldType({required this.type});
  String type;

  Map<String, Object?> toJson() {
    switch(runtimeType){
      case CollectionFieldTypeSimple:
        return (this as CollectionFieldTypeSimple).toJson();
      case CollectionFieldTypeTextChoice:
        return (this as CollectionFieldTypeTextChoice).toJson();
      default:
        throw Exception("Not allowed type");
    }

  }

  static CollectionFieldType fromJson(Map<String, dynamic> json){
    if(json.containsKey("CollectionFieldTypeTextChoice.choices")){
      return CollectionFieldTypeTextChoice.fromJson(json);
    }else{
      return CollectionFieldTypeSimple.fromJson(json);
    }
  }

}

class CollectionFieldTypeSimple extends CollectionFieldType
{
   CollectionFieldTypeSimple(String type) : super(type:type);

   @override
   Map<String, Object?> toJson() {
     return {
       'type': type
     };
   }

   CollectionFieldTypeSimple.fromJson(Map<String, dynamic> json): this(
     json['type']
   );
}


class CollectionFieldTypeTextChoice extends CollectionFieldType
{
  CollectionFieldTypeTextChoice(String type, {required this.choices}) : super(type:type);

  List<String> choices;

  @override
  Map<String, Object?> toJson() {
    return {
      'type': type,
      'CollectionFieldTypeTextChoice.choices': choices,
    };
  }

  CollectionFieldTypeTextChoice.fromJson(Map<String, dynamic> json): this(
    json['type'],
    choices: (json['CollectionFieldTypeTextChoice.choices'] as List).map((e) => e as String).toList(),
  );
}