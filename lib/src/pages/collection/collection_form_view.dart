import 'dart:io';
import 'package:my_things/src/common/common.dart';
import 'package:my_things/src/components/form_fields/image_form_field.dart';
import 'package:my_things/src/components/form_fields/key_value_form_field.dart';
import 'package:my_things/src/model/collection_field.dart';
import 'package:my_things/src/model/collection_field_type.dart';
import 'package:my_things/src/model/item_field.dart';
import 'package:my_things/src/pages/collection/collection_form_view_model.dart';
import 'package:my_things/src/service/frontend/dialog_service.dart';
import 'package:my_things/src/service/frontend/toaster_service.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class CollectionFormView extends StatelessWidget{
  const CollectionFormView({Key? key, required this.viewModel,  required this.formKey, required this.onChanged}) : super(key: key);
  final GlobalKey<FormState>                    formKey;
  final CollectionFormViewModel                 viewModel;
  final ValueChanged<CollectionFormViewModel>   onChanged;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel ,
      child: _CollectionFormView( formKey: formKey, onChanged:  onChanged)
    );
  }
}

class _CollectionFormView extends StatefulWidget {
  const _CollectionFormView({Key? key,  required this.formKey, required this.onChanged}) : super(key: key);
  final GlobalKey<FormState>                    formKey;
  final ValueChanged<CollectionFormViewModel>   onChanged;

  @override
  State<StatefulWidget> createState() => _CollectionFormState();
}


class _CollectionFormState extends State<_CollectionFormView> {

  final                                   _attrformKey = GlobalKey<FormState>();
  late CollectionField                    _attrformValue;
  late DialogService  dialogService = DialogService(context);

  Widget fieldRow(CollectionField field, bool deletable, CollectionFormViewModel viewModel){
    Map<String, String> fieldTypesNames = CollectionField.fieldTypes(context);
    String fieldValue = fieldTypesNames[field.type.type]!;
    if(field.type is CollectionFieldTypeTextChoice){
      fieldValue = fieldTypesNames[field.type.type]! + " ( " + (field.type as CollectionFieldTypeTextChoice).choices.toString() + " ) ";
    }
    return Row(
      children: [
        Expanded(child: Text(field.name), flex: 1,),
        const SizedBox(width: 10,),
        Expanded(child: Text(fieldValue), flex: 1,),

        IconButton(
          onPressed: deletable == false  ? null
            : (){
              setState(() {
                viewModel.removeField(field);
              });
            },
          icon: const Icon(Icons.delete),
        )
      ],
    );
  }

  Widget fieldList(CollectionFormViewModel viewModel){
    List<Widget> fieldList = [];
    Map<String, String> fieldTypesNames = CollectionField.fieldTypes(context);

    for (var field in viewModel.fields) {
      if(viewModel.mode == CollectionFormMode.CREATE){
        fieldList.add(fieldRow(field, true, viewModel));
      }
      if(viewModel.mode == CollectionFormMode.READ){
        fieldList.add(Row(children: [
          Expanded(child: Text(field.name),),
          Expanded(child: Text(fieldTypesNames[field.type]!),)
        ],));
      }

    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: fieldList,
    );
  }

  Widget defaultViewFieldRow(CollectionFormViewModel viewModel, MapEntry<String, bool> fieldChecked, bool checkable){
    return CheckboxListTile(
      title: Text(fieldChecked.key),
      value: fieldChecked.value,
      dense: true,
      contentPadding: const EdgeInsets.all(0),
      onChanged: checkable == false || viewModel.mode == CollectionFormMode.READ  ? null
        : (newValue){
          setState((){
            if(viewModel.defaultViewFields.any((fieldName) => fieldName == fieldChecked.key)) {
              viewModel.removeFieldView(fieldChecked.key);
            }else{
              viewModel.addFieldView(fieldChecked.key);
            }
        });

      },
    );
  }

  Widget defaultViewFieldList(CollectionFormViewModel viewModel, Map<String, bool> fieldViewChecked){
    List<Widget> viewFieldList = [];

    for (var fieldViewCheck in fieldViewChecked.entries) {
      viewFieldList.add(defaultViewFieldRow(viewModel, fieldViewCheck, true));
    }

    return Column(children: viewFieldList);
  }



  @override
  Widget build(BuildContext context) {
    CollectionFormViewModel viewModel = Provider.of<CollectionFormViewModel>(context);
    Map<String, bool> fieldViewChecked = {};
    for (var field in viewModel.fields) {
      fieldViewChecked[field.name] = viewModel.defaultViewFields.any((fieldName) => fieldName == field.name) ? true : false;
    }

    void formAddFieldChanged(String fieldName, String fieldValue){
      CollectionFieldType fieldType = CollectionFieldTypeSimple(fieldValue);
      if(fieldValue == ItemFieldDropDownText.TYPE_NAME || fieldValue == ItemFieldCheckBoxList.TYPE_NAME ){
        fieldType = CollectionFieldTypeTextChoice(fieldValue, choices: List.empty(growable: true));
      }
      _attrformValue = CollectionField(fieldName, fieldType, false);
    }

    void addFormField() async {
      if(_attrformKey.currentState!.validate() == true){
        if(!viewModel.hasField(_attrformValue)){

          if(_attrformValue.type is CollectionFieldTypeTextChoice){
            List<String>? choices =   await dialogService.showEditTextListDialog(List.empty(growable: true),
                AppLocalizations.of(context)!.textChoicesOf(_attrformValue.name) );
            if(choices != null && choices.isNotEmpty) {
              (_attrformValue.type as CollectionFieldTypeTextChoice).choices = choices;
              _attrformKey.currentState!.reset();
              viewModel.addField(_attrformValue);
              widget.onChanged(viewModel);
            }else{
              ToasterService(context).dangerToaster(AppLocalizations.of(context)!.emptyField(_attrformValue.name));
            }
          }
          if(_attrformValue.type is CollectionFieldTypeSimple){
            _attrformKey.currentState!.reset();
            viewModel.addField(_attrformValue);
            widget.onChanged(viewModel);
          }

        }else{
          ToasterService(context).dangerToaster(AppLocalizations.of(context)!.errorCollectionFieldAlreadyExist);
        }
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0),
      child: Column(
        children: [
          Form(
            key: widget.formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: Provider.of<CollectionFormViewModel>(context).name,
                  onChanged: (s) {
                    viewModel.setTitle(s);
                    widget.onChanged(viewModel);
                  },
                  maxLength: 50,
                  validator: (s) => s!.isEmpty || s.isEmpty ?  AppLocalizations.of(context)!.errorLength(1, 50) : null,
                  decoration: InputDecoration(hintText: AppLocalizations.of(context)!.collectionTitle, labelText: AppLocalizations.of(context)!.collectionTitle),
                ),
                const SizedBox(height: 10.0),

                ImageFormField(
                  label: AppLocalizations.of(context)!.collectionImage(viewModel.name ?? ""),
                  startNetworkImage: viewModel.image == null && viewModel.collectionUsedToCreate !=null ? viewModel.collectionUsedToCreate!.image.downloadUrl : null,
                  onChanged: (File? file) {
                    viewModel.setImage(file);
                    widget.onChanged(viewModel);
                  },
                  currentValue: viewModel.image,
                  enabled: viewModel.mode != CollectionFormMode.READ,
                ),
                const SizedBox(height: 20.0),

              ],
            ),
          ),
          viewModel.mode != CollectionFormMode.CREATE && viewModel.mode != CollectionFormMode.READ ? SizedBox() :
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1
              )
            ) ,
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Text(AppLocalizations.of(context)!.collectionFields(viewModel.name ?? ""), style: Theme.of(context).textTheme.bodyText1,),
                const SizedBox(height: 30,),
                viewModel.mode == CollectionFormMode.CREATE
                    ? Form(
                      key: _attrformKey,
                      child: Row(
                        children: [
                          Expanded(child: KeyValueFormField(
                              valueList: CollectionField.fieldTypes(context).entries.map((validType)  {
                                return DropdownMenuItem<String>(child: Text(validType.value),value: validType.key);
                              }).toList(),
                              onChanged: (tuple){
                                formAddFieldChanged(tuple.item1, tuple.item2);
                              },
                              currentValue:  const Tuple2<String, String> ("",ItemFieldTextLong.TYPE_NAME)),
                          ),

                          IconButton(
                            onPressed: () async {
                              addFormField();
                            },
                            icon: const Icon(Icons.add),
                          )
                        ],
                      ),
                    )
                    : const SizedBox(),
                fieldList(viewModel),
              ],
            ),
          ),
          const SizedBox(height: 20,),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.grey,
                    width: 1
                )
            ) ,
            padding: const EdgeInsets.all(8),
            child: Column(children: [
              Text(AppLocalizations.of(context)!.collectionDefaultFieldView, style: Theme.of(context).textTheme.bodyText1,),
              const SizedBox(height: 30,),
              defaultViewFieldList(viewModel, fieldViewChecked)
            ],),
          ),

          const SizedBox(height: 50,),

        ],
      ),
  );

  }
}