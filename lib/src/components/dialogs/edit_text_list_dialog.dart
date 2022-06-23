import 'package:flutter/material.dart';
import 'package:my_things/src/common/common.dart';


class EditTextListDialog extends StatefulWidget {
  /// Optionally overwrite the filename of a new photo taken with the camera
  const EditTextListDialog(this.title, this.textList, {Key? key}) : super(key: key);

  final String  title;
  final List<String> textList;

  @override
  State<StatefulWidget> createState() => _EditTextListDialogState();
}

class _EditTextListDialogState extends State<EditTextListDialog>
{
  late List<String> newTextList = widget.textList;
  GlobalKey<FormState>   formKey = GlobalKey<FormState>();
  String                 formValue = "";

  Widget textList(context){
    List<Widget> fieldList = [];

    for (var text in newTextList) {
      fieldList.add(Row(
        children: [
          Expanded(child: Text(text)),
          IconButton(
            onPressed: (){
              setState(() {
                newTextList.remove(text);
              });
            },
            icon: const Icon(Icons.delete),
          )
        ],
      ));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: fieldList,
    );
  }

  Widget form(context){
    return Form(
      key: formKey,
      child: (
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: widget.title,

                  ),
                  validator: (fieldName)  {
                    if(fieldName!.length < 3 || fieldName.length > 30 ){
                      return AppLocalizations.of(context)!.errorLength(3, 30);
                    }
                  },
                  onChanged: (newFieldName) {
                    setState(() {
                      formValue = newFieldName;
                    });
                  },
                )
                ,flex: 1,),
              IconButton(
                onPressed: () async {
                  if(formKey.currentState!.validate() == true){
                    setState(() {
                      newTextList.add(formValue);
                    });
                    formKey.currentState!.reset();
                  }
                },
                icon: const Icon(Icons.add),
              )
            ],
          )
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        height: 400,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(color: Colors.black,offset: Offset(0,10),
                  blurRadius: 10
              ),
            ]
        ),
        child: SingleChildScrollView(child:Column(
          children: [
            form(context),
            textList(context),
            ElevatedButton(
              child: Text(
                AppLocalizations.of(context)!.confirmAction,
                style: const TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                Navigator.pop(context, newTextList);
              },
            ),

          ],
        ),
      ),

    ));
  }

}