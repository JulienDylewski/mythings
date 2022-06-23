import 'package:my_things/src/common/common.dart';
import 'package:my_things/src/model/collection_field.dart';
import 'package:my_things/src/model/item.dart';
import 'package:my_things/src/model/item_field.dart';
import 'package:my_things/src/model/filters.dart';

class ItemListViewModel extends ChangeNotifier{
  ItemListViewModel._privateConstructor();
  static final ItemListViewModel _instance = ItemListViewModel._privateConstructor();
  static ItemListViewModel get instance => _instance;

  List<Item> items = List.empty(growable: true);
  List<Item> _itemsWithoutFilters = List.empty(growable: true);
  List<Filter> filters = List.empty(growable: true);



  setCollectionItems(List<Item> newItems){
    items = newItems;
    _itemsWithoutFilters = newItems;

    notifyListeners();
  }

  setEmptyFiltersWithCollectionFields(List<CollectionField> collectionFields){
    filters = Filter.emptyFiltersFromCollectionFieldList(collectionFields);
  }

  setFilters(List<Filter> filters ){
    filters =  filters;
  }

  addCollectionItem(Item item){
    items.insert(0, item);
    _itemsWithoutFilters = items;
    notifyListeners();
  }

  editCollectionIten(Item newItem){
    items[items.indexWhere((item) => item.docRef == newItem.docRef)] = newItem;
    _itemsWithoutFilters = items;
    notifyListeners();
  }

  deleteCollectionItem(Item itemToDelete){
    items.removeAt(items.indexWhere((item) => item.docRef == itemToDelete.docRef));
    _itemsWithoutFilters = items;
    notifyListeners();
  }

  applyFilters(){
    if(filters.isEmpty){
      notifyListeners();
      items = _itemsWithoutFilters;
      return;
    }
    List<Item> newItems = List.empty(growable: true);
    for(Item item in _itemsWithoutFilters){
      if(Filter.filtersAreEmpty(filters) == false){
        bool shouldDisplayItem = true;
        shouldDisplayItemLoop:
        for(ItemField field in item.fields){
          for(Filter filter in filters){
            bool? matchFilter = _fieldMatchFilter(field, filter);
            if(matchFilter != null){
              if(matchFilter == false){
                shouldDisplayItem = false;
                break shouldDisplayItemLoop;
              }
            }

          }
        }
        if(shouldDisplayItem){
          newItems.add(item);
        }
      }else{
        newItems.add(item);
      }
    }
    items = newItems;
    notifyListeners();
  }


  bool? _fieldMatchFilter(ItemField field, Filter filter ){
    if(field is ItemFieldTextLong   && filter is TextFilter){
      if(filter.contain == null || field.value == null || filter.key != field.name){
        return null;
      }
      return field.value!.contains(filter.contain!);
    }
    if(field is  ItemFieldTextShort && filter is TextFilter){
      if(filter.contain == null || field.value == null || filter.key != field.name){
        return null;
      }
      return field.value!.contains(filter.contain!);
    }
    if(field is ItemFieldNumber && filter is NumberFilter){
      bool minFilter = filter.min != null;
      bool maxFilter = filter.max != null;
      bool betweenFilter = minFilter && maxFilter;
      if(filter.key != field.name || (!minFilter && !maxFilter)){
        return null;
      }
      if(field.value == null){
        return false;
      }

      if(betweenFilter){
        return field.value! >= filter.min! && field.value! <= filter.max!;
      }
      if(minFilter){
        return field.value! >= filter.min!;
      }
      if(maxFilter){
        return field.value! <= filter.max!;
      }
      return false;
    }
    if(field is ItemFieldDate && filter is DateFilter){
      bool minFilter = filter.dateMin != null;
      bool maxFilter = filter.dateMax != null;
      bool betweenFilter = minFilter && maxFilter;
      if(filter.key != field.name || (!minFilter && !maxFilter)){
        return null;
      }
      if(field.value == null){
        return false;
      }

      if(betweenFilter){
        return field.value!.isAfter(filter.dateMin!) &&  field.value!.isBefore(filter.dateMax!) ;
      }
      if(minFilter){
        return field.value!.isAfter(filter.dateMin!);
      }
      if(maxFilter){
        return  field.value!.isBefore(filter.dateMax!);
      }
      return false;
    }
    if(field is ItemFieldImage && filter is ImageFilter){
      if(filter.key != "ALL" || filter.withImages == null ){
        return null;
      }
      if(filter.withImages! == true){
        return field.value != null;
      }else{
        return field.value == null;
      }
    }
    if(field is ItemFieldCheckBox && filter is BoolFilter){
      if(!filter.falseChecked && !filter.trueChecked ){
        return null;
      }
      if(filter.trueChecked && filter.falseChecked){
        return true;
      }
      if(filter.trueChecked && field.value){
        return true;
      }
      if(filter.falseChecked && !field.value){
        return true;
      }
      return false;
    }
    if(field is ItemFieldDropDownText && filter is TextMultipleChoiceFilter){
      if(filter.enabled == false || filter.key != field.name){
        return null;
      }
      return field.value != null ?  filter.selectedChoices.contains(field.value) : false;
    }
    if(field is ItemFieldCheckBoxList && filter is TextMultipleChoiceFilter){
      if(filter.enabled == false || filter.key != field.name){
        return null;
      }
      for(String value in field.value){
        if(filter.selectedChoices.contains(value)){
          return true;
        }
      }
      return false;
    }

    return null;
  }


}