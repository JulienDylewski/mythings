import 'package:my_things/src/common/common.dart';
import 'package:my_things/src/components/form_fields/date_form_field.dart';
import 'package:my_things/src/components/form_fields/image_form_field.dart';
import 'package:my_things/src/components/form_fields/number_form_field.dart';
import 'package:my_things/src/model/collection_field.dart';
import 'package:my_things/src/model/collection_field_type.dart';
import 'package:my_things/src/model/item_field.dart';
import 'package:my_things/src/pages/item/item_form_view_model.dart';
import 'package:provider/provider.dart';

class ItemFormView extends StatelessWidget{
  const ItemFormView({Key? key, required this.viewModel,  required this.formKey, required this.onChanged}) : super(key: key);
  final GlobalKey<FormState>                    formKey;
  final ItemFormViewModel                 viewModel;
  final ValueChanged<ItemFormViewModel>   onChanged;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: viewModel ,
        child: _ItemFormView( formKey: formKey, onChanged:  onChanged)
    );
  }
}

class _ItemFormView extends StatefulWidget {
  const _ItemFormView({Key? key,  required this.formKey, required this.onChanged}) : super(key: key);
  final GlobalKey<FormState>                    formKey;
  final ValueChanged<ItemFormViewModel>   onChanged;


  @override
  State<StatefulWidget> createState() => _ItemFormViewState();
}

Widget formFields(ItemFormViewModel viewModel, BuildContext context ) {
  List<Widget> fields = List.empty(growable: true);

  for(ItemField field in viewModel.fields){

    if(field is ItemFieldTextShort ){
      fields.add(
          TextFormField(
            maxLength: 50,
            initialValue: field.value,
            decoration: InputDecoration(labelText: "${field.name} (${CollectionField.fieldTypes(context)[field.type]})"),
            onChanged: (value){
              viewModel.setShortTextItemValue(field.name, value);
            },
          )
      );
    }

    if(field is ItemFieldTextLong ){
      fields.add(
          TextFormField(
            maxLength: 500,
            maxLines: 5,
            initialValue: field.value,
            decoration: InputDecoration(labelText:  "${field.name} (${CollectionField.fieldTypes(context)[field.type]})"),
            onChanged: (value){
              viewModel.setLongTextItemValue(field.name, value);
            },
          )
      );
    }

    if(field is ItemFieldImage){
      fields.add(
        ImageFormField(
          validator: (file){return;},
          onChanged: (file){
            viewModel.setImageItemValue(field.name, file);
          },
          currentValue: field.file,
          startNetworkImage: field.value != null ? field.value!.downloadUrl : null,
          enabled: true,
          label: "${field.name} (${CollectionField.fieldTypes(context)[field.type]})",
        )
      );
    }

    if(field is ItemFieldNumber){
      fields.add(
          NumberFormField(
              onChanged: (value){
                viewModel.setNumberItemValue(field.name, value);
              },
              currentValue: field.value,
              label:  "${field.name} (${CollectionField.fieldTypes(context)[field.type]})"
          )

      );
    }

    if(field is ItemFieldDate){
      fields.add(
          DateFormField(
              onChanged: (value){
                viewModel.setDateItemValue(field.name, value);
              },
              currentValue: field.value,
              label:  "${field.name} (${CollectionField.fieldTypes(context)[field.type]})"
          )
      );
    }

    if(field is ItemFieldDropDownText){
      CollectionFieldType collectionFieldType = viewModel.collection.fields.firstWhere((element) => element.name == field.name).type;
      List<String> choices = [...((collectionFieldType as CollectionFieldTypeTextChoice).choices)];
      choices.add("");
      fields.add(
          DropdownButtonFormField<String>(
              value: field.value ?? "",
              decoration: InputDecoration(
                  labelText: "${field.name} (${CollectionField.fieldTypes(context)[field.type]})",
                  contentPadding: const EdgeInsets.only(top: 0, bottom: 0,left: 10)
              ),
              onChanged: (newFieldValue) {
                viewModel.setDropDownTextValue(field.name, newFieldValue == "" ? null : newFieldValue);
              },
              items: choices.map((choice) => DropdownMenuItem<String>(child: Text(choice),value: choice)).toList()
          )
      );
    }
    if(field is ItemFieldCheckBoxList){
      CollectionFieldType collectionFieldType = viewModel.collection.fields.firstWhere((element) => element.name == field.name).type;
      List<String> choices = [...((collectionFieldType as CollectionFieldTypeTextChoice).choices)];
      List<Widget> checkboxs = List.empty(growable: true);
      for(String selectedChoice in choices){
        checkboxs.add(CheckboxListTile(
          title: Text(selectedChoice),
          value: field.value != null ? field.value.contains(selectedChoice) : false,
          onChanged: (bool? value) { // This is where we update the state when the checkbox is tapped
            viewModel.setCheckboxListValue(field.name, selectedChoice, value!);
          },
        ));
      }
      fields.add(
        Card(
          elevation: 2,
          child: Column(children: [
            ListTile(title: ListTile(title: Text("${field.name} (${CollectionField.fieldTypes(context)[field.type]})"),),),
            Column(
              children: checkboxs,
            )
          ],),
        )
      );
    }
    if(field is ItemFieldCheckBox){
      fields.add(
          CheckboxListTile(
            title: Text("${field.name} (${CollectionField.fieldTypes(context)[field.type]})"),
            value: field.value,
            onChanged: (bool? value) { // This is where we update the state when the checkbox is tapped
              viewModel.setCheckBoxValue(field.name, value!);
            },
          )
      );
    }

    fields.add(const SizedBox(height: 10,));
  }

  return Column(
    children: fields,
  );
}


class _ItemFormViewState extends State<_ItemFormView> {

  @override
  Widget build(BuildContext context) {
    ItemFormViewModel viewModel = Provider.of<ItemFormViewModel>(context);

    return Form(
      key: widget.formKey,
      child: formFields(viewModel, context),
    );
  }
}