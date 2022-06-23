

import 'package:my_things/src/model/collection_field.dart';
import 'package:my_things/src/model/collection_field_type.dart';

import 'item_field.dart';

abstract class Filter{
  Filter(this.key);
  // key used to filter all fields
  static String keyForAll = "ALL";

  void clear();
  bool isEmpty();

  static bool filtersAreEmpty(List<Filter> filters){
    for(Filter f in filters){
      if(f.isEmpty() == false){
        return false;
      }
    }
    return true;
  }

  static List<Filter> clearFilters(List<Filter> filters){
    for(Filter f in filters){
      f.clear();
    }
    return filters;
  }

  static List<Filter> emptyFiltersFromCollectionFieldList(List<CollectionField> collectionFields){
    List<Filter> filters = List.empty(growable: true);
    bool hasImage = false;
    for(CollectionField field in collectionFields){
      if(field.type.type == ItemFieldTextLong.TYPE_NAME || field.type.type ==  ItemFieldTextShort.TYPE_NAME){
        filters.add(TextFilter(field.name));
      }
      if(field.type.type == ItemFieldNumber.TYPE_NAME){
        filters.add(NumberFilter(field.name));
      }
      if(field.type.type == ItemFieldDate.TYPE_NAME){
        filters.add(DateFilter(field.name));
      }
      if(field.type.type == ItemFieldImage.TYPE_NAME){
        hasImage = true;
      }
      if(field.type.type == ItemFieldCheckBox.TYPE_NAME){
        filters.add(BoolFilter(field.name));
      }
      if(field.type.type == ItemFieldDropDownText.TYPE_NAME){
        CollectionFieldTypeTextChoice fieldTypeTextChoice = field.type as CollectionFieldTypeTextChoice;
        filters.add(TextMultipleChoiceFilter(field.name, [...fieldTypeTextChoice.choices], selectedChoices: List.empty(growable: true)));
      }
      if(field.type.type == ItemFieldCheckBoxList.TYPE_NAME){
        CollectionFieldTypeTextChoice fieldTypeTextChoice = field.type as CollectionFieldTypeTextChoice;
        filters.add(TextMultipleChoiceFilter(field.name, [...fieldTypeTextChoice.choices], selectedChoices: List.empty(growable: true)));
      }
    }
    if(hasImage){
      filters.add(ImageFilter(Filter.keyForAll));
    }
    return filters;
  }


  String? key;
}

class TextFilter extends Filter {
  TextFilter(String fieldName, {this.contain}) : super(fieldName);

  String? contain;

  factory TextFilter.contain(String fieldName, String textContained)
    => TextFilter(fieldName, contain: textContained);

  @override
  void clear() {
    contain = null;
  }

  @override
  bool isEmpty() {
    return contain == null;
  }
}

class NumberFilter extends Filter {
  NumberFilter(String fieldName , {this.min, this.max}) : super(fieldName);

  double? min;
  double? max;

  factory NumberFilter.between(String fieldName, double? min, double? max)
  => NumberFilter(fieldName,  min:min, max:max);

  @override
  void clear() {
    min = null;
    max = null;
  }

  @override
  bool isEmpty() {
    return min == null && max == null;
  }


}

class DateFilter extends Filter {
  DateFilter(String fieldName, {this.dateMin, this.dateMax}) : super(fieldName);

  DateTime? dateMin;
  DateTime? dateMax;

  factory DateFilter.between(String fieldName, DateTime? min, DateTime? max)
  => DateFilter(fieldName,  dateMin:min, dateMax:max);

  @override
  void clear() {
    dateMin = null;
    dateMax = null;
  }

  @override
  bool isEmpty() {
    return dateMin == null && dateMax == null;
  }
}

class ImageFilter extends Filter {
  ImageFilter(String fieldName ,{this.withImages}) : super(fieldName);

  bool? withImages;

  factory ImageFilter.onlyWithImage(bool withImages) => ImageFilter(Filter.keyForAll, withImages: withImages );

  @override
  void clear() {
    withImages = null;
  }

  @override
  bool isEmpty() {
    return withImages == null;
  }
}

class BoolFilter extends Filter {
  BoolFilter(String fieldName, {this.trueChecked = false, this.falseChecked = false}) : super(fieldName);

  bool trueChecked;
  bool falseChecked;

  @override
  void clear() {
    trueChecked = false;
    falseChecked = false;
  }

  @override
  bool isEmpty() {
    return !trueChecked && !falseChecked ;
  }
}

class TextChoiceFilter extends Filter {
  TextChoiceFilter(String fieldName, this.choices , {this.selectedChoice}) : super(fieldName);

  List<String> choices;
  String? selectedChoice;

  @override
  void clear() {
    selectedChoice = null;
  }

  @override
  bool isEmpty() {
    return selectedChoice == null;
  }
}

class TextMultipleChoiceFilter extends Filter {
  TextMultipleChoiceFilter(String fieldName, this.choices , {required this.selectedChoices, this.enabled = false}) : super(fieldName);
  List<String> choices;
  List<String> selectedChoices;
  bool enabled;

  void clear() {
    selectedChoices.clear();
    enabled = false;
  }

  @override
  bool isEmpty() {
    return selectedChoices.isEmpty && enabled == false;
  }

}

