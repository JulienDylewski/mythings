import 'dart:io';

import 'package:my_things/src/model/app_file.dart';

// TODO: collectionItem value, name discriminer
abstract class ItemField {
  ItemField(this.name, this.type);

  String name;
  String type;

  Map<String, Object?> toJson() {
    switch(runtimeType){
      case ItemFieldTextShort:
        return (this as ItemFieldTextShort).toJson();
      case ItemFieldTextLong:
        return (this as ItemFieldTextLong).toJson();
      case ItemFieldImage:
        return (this as ItemFieldImage).toJson();
      case ItemFieldNumber:
        return (this as ItemFieldNumber).toJson();
      case ItemFieldDate:
        return (this as ItemFieldDate).toJson();
      case ItemFieldDropDownText:
        return (this as ItemFieldDropDownText).toJson();
      case ItemFieldCheckBoxList:
        return (this as ItemFieldCheckBoxList).toJson();
      case ItemFieldCheckBox:
        return (this as ItemFieldCheckBox).toJson();
      default:
        throw Exception("Not allowed type");
    }

  }

  static ItemField fromJson(Map<String, dynamic> json){
    switch(json['type']){
      case ItemFieldTextShort.TYPE_NAME:
        return ItemFieldTextShort.fromJson(json);
      case ItemFieldTextLong.TYPE_NAME:
        return ItemFieldTextLong.fromJson(json);
      case ItemFieldImage.TYPE_NAME:
        return ItemFieldImage.fromJson(json);
      case ItemFieldNumber.TYPE_NAME:
        return ItemFieldNumber.fromJson(json);
      case ItemFieldDate.TYPE_NAME:
        return ItemFieldDate.fromJson(json);
      case ItemFieldDropDownText.TYPE_NAME:
        return ItemFieldDropDownText.fromJson(json);
      case ItemFieldCheckBoxList.TYPE_NAME:
        return ItemFieldCheckBoxList.fromJson(json);
      case ItemFieldCheckBox.TYPE_NAME:
        return ItemFieldCheckBox.fromJson(json);
      default:
        throw Exception("Not allowed type");
    }
  }

  ItemField clone(){
    return ItemField.fromJson(toJson());
  }

  static List<ItemField> cloneList(List<ItemField> fields){
    List<ItemField> newFields = List.empty(growable: true);
    for(ItemField field in fields){
      newFields.add(field.clone());
    }
    return newFields;
  }

}


class ItemFieldTextShort extends ItemField{
  static const TYPE_NAME = "TEXT_SHORT";

  String? value;

  ItemFieldTextShort({
    required String name,
    this.value
  })
  : super(name, ItemFieldTextShort.TYPE_NAME);

  @override
  Map<String, Object?> toJson() {
    return {
      'name': name,
      'type': type,
      'value': value
    };
  }

  ItemFieldTextShort.fromJson(Map<String, dynamic> json): this(
      name: json['name'],
      value: json['value'],
  );
}

class ItemFieldTextLong extends ItemField{
  static const TYPE_NAME = "TEXT_LONG";

  String? value;

  ItemFieldTextLong({
    required String name,
    this.value})
  : super(name, ItemFieldTextLong.TYPE_NAME);

  @override
  Map<String, Object?> toJson() {
    return {
      'name': name,
      'type': type,
      'value': value
    };
  }

  ItemFieldTextLong.fromJson(Map<String, dynamic> json): this(
    name: json['name'],
    value: json['value'],
  );
}

class ItemFieldImage extends ItemField{
  static const TYPE_NAME = "IMAGE";

  File? file;
  AppFile? value;

  ItemFieldImage({
    required String name,
    this.value})
  : super(name,  ItemFieldImage.TYPE_NAME);

  @override
  Map<String, Object?> toJson() {
    return {
      'name': name,
      'type': type,
      'value': value?.toJson() ?? ""
    };
  }

  ItemFieldImage.fromJson(Map<String, dynamic> json): this(
    name: json['name'],
    value:  json['value'] != "" ? AppFile.fromJson(json['value']) : null,
  );

  @override
  ItemFieldImage clone() {
    ItemFieldImage copy =  ItemFieldImage.fromJson(toJson());
    copy.file = file;
    return copy;
  }
}


class ItemFieldNumber extends ItemField{
  static const TYPE_NAME = "NUMBER";

  double? value;

  ItemFieldNumber({
    required String name,
    this.value})
  : super(name,  ItemFieldNumber.TYPE_NAME);

  @override
  Map<String, Object?> toJson() {
    return {
      'name': name,
      'type': type,
      'value': value
    };
  }

  ItemFieldNumber.fromJson(Map<String, dynamic> json): this(
    name: json['name'],
    value: json['value'] == "" ? null : json['value']  ,
  );
}

class ItemFieldDate extends ItemField {
  static const TYPE_NAME = "DATE";

  DateTime? value;

  ItemFieldDate({required String name, this.value})
      : super(name, ItemFieldDate.TYPE_NAME);

  @override
  Map<String, Object?> toJson() {
    return {
      'name': name,
      'type': type,
      'value': value?.toIso8601String() ?? ""
    };
  }

  ItemFieldDate.fromJson(Map<String, dynamic> json): this(
    name: json['name'],
    value: json['value'] == "" ? null : DateTime.parse(json['value'])  ,
  );

}

class ItemFieldDropDownText extends ItemField {
  static const TYPE_NAME = "DROPDOWN_TEXT";

  String? value;

  ItemFieldDropDownText({
    required String name,
    this.value
  })
      : super(name, ItemFieldDropDownText.TYPE_NAME);

  @override
  Map<String, Object?> toJson() {
    return {
      'name': name,
      'type': type,
      'value': value
    };
  }

  ItemFieldDropDownText.fromJson(Map<String, dynamic> json): this(
    name: json['name'],
    value: json['value'],
  );
}

class ItemFieldCheckBoxList extends ItemField {
  static const TYPE_NAME = "CHECKBOX_LIST";

  List<String> value;

  ItemFieldCheckBoxList({
    required String name,
    required this.value
  })
      : super(name, ItemFieldCheckBoxList.TYPE_NAME);

  @override
  Map<String, Object?> toJson() {
    return {
      'name': name,
      'type': type,
      'value': value
    };
  }

  ItemFieldCheckBoxList.fromJson(Map<String, dynamic> json): this(
    name: json['name'],
    value:  (json['value'] as List).map((e) => e as String).toList(),
  );
}

class ItemFieldCheckBox extends ItemField {
  static const TYPE_NAME = "CHECKBIX";

  bool value;

  ItemFieldCheckBox({
    required String name,
    required this.value
  })
      : super(name, ItemFieldCheckBox.TYPE_NAME);

  @override
  Map<String, Object?> toJson() {
    return {
      'name': name,
      'type': type,
      'value': value
    };
  }

  ItemFieldCheckBox.fromJson(Map<String, dynamic> json): this(
    name: json['name'],
    value:  json['value'],
  );
}