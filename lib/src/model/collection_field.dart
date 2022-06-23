import 'package:flutter/cupertino.dart';
import 'package:my_things/src/common/common.dart';
import 'package:my_things/src/model/collection_field_type.dart';
import 'package:my_things/src/model/item_field.dart';

class CollectionField{
  CollectionField(this.name, this.type, this.required);

  String name;
  CollectionFieldType type;
  bool   required;


  Map<String, Object?> toJson() {
    return {
      'name': name,
      'type': type.toJson(),
      'required': required,
    };
  }
  CollectionField.fromJson(Map<String, dynamic> json): this(
    json['name']! ,
    CollectionFieldType.fromJson(json['type']!),
    json['required']!
  );

  static Map<String, String> fieldTypes(BuildContext context) {
    return {ItemFieldTextShort.TYPE_NAME: AppLocalizations.of(context)!.textShort, ItemFieldTextLong.TYPE_NAME: AppLocalizations.of(context)!.textLong,
      ItemFieldNumber.TYPE_NAME: AppLocalizations.of(context)!.number, ItemFieldImage.TYPE_NAME: AppLocalizations.of(context)!.image,
      ItemFieldDate.TYPE_NAME: AppLocalizations.of(context)!.date, ItemFieldDropDownText.TYPE_NAME : AppLocalizations.of(context)!.dropdownText,
      ItemFieldCheckBoxList.TYPE_NAME : AppLocalizations.of(context)!.checkboxList,
      ItemFieldCheckBox.TYPE_NAME : AppLocalizations.of(context)!.checkbox,
    };
  }

  @override
  bool operator ==(Object other) {
    if(other is CollectionField){
      return name.toLowerCase() == other.name.toLowerCase();
    }
    return super == other;
  }
}

