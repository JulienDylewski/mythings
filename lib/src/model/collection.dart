import 'package:my_things/src/model/app_file.dart';
import 'package:my_things/src/model/collection_field_view.dart';
import 'collection_field.dart';

class Collection {
  Collection({this.docRef, required this.name, required this.image, required this.userUid,
    required this.fields, required this.fieldViews, required this.createdAt, required this.updatedAt});

  String? docRef;
  String? userUid;
  String  name;
  AppFile image;
  DateTime createdAt;
  DateTime updatedAt;
  List<CollectionField> fields;
  List<CollectionFieldView> fieldViews;

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'userUid': userUid,
      'image': image.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': createdAt.toIso8601String(),
      'fields':  fields.map((field) {
        return field.toJson();
      }).toList(),
      'fieldViews': fieldViews.map((fieldView) {
        return fieldView.toJson();
      }).toList(),
    };
  }

  Collection.fromJson(Map<String, dynamic> json): this(
    name: json['name']! as String,
    userUid: json['userUid'] as String,
    image:  AppFile.fromJson(json['image']),
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt : DateTime.parse(json['updatedAt']),
    fields: !json.containsKey('fields') || json['fields'] ==  null ? []
        : (json['fields'] as List).map((e) => CollectionField.fromJson(e)).toList(),
    fieldViews: !json.containsKey('fieldViews') || json['fieldViews'] == null  ? []
        : (json['fieldViews'] as List).map((fieldView) =>  CollectionFieldView.fromJson(fieldView)).toList()

  );
}

