import 'package:my_things/src/model/collection_field.dart';
import 'package:my_things/src/model/item_field.dart';

class Item{
  Item(this.collectionRef, this.userUid, this.fields, this.createdAt, this.updatedAt );

  String collectionRef;
  String userUid;
  String? docRef;
  DateTime createdAt;
  DateTime updatedAt;
  List<ItemField> fields;

  Map<String, Object?> toJson() {
    return {
      'collectionRef': collectionRef,
      'userUid': userUid,
      'fields': fields.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': createdAt.toIso8601String(),
    };
  }

  static Item fromJson(Map<String, dynamic> json){
    String name = "";
    List<ItemField> fields  = (json['fields'] as List).map((json) {
      return ItemField.fromJson(json);
    }).toList();
    return Item(
        json['collectionRef'],
        json['userUid'],
        fields,
        DateTime.parse(json['createdAt']),
        DateTime.parse(json['updatedAt']),
    );
  }
}