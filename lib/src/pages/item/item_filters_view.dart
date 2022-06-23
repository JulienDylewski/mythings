import 'package:my_things/src/common/common.dart';
import 'package:my_things/src/components/form_fields/date_form_field.dart';
import 'package:my_things/src/components/form_fields/number_form_field.dart';
import 'package:my_things/src/model/filters.dart';

class ItemFiltersView extends StatefulWidget{
  const ItemFiltersView(this.filters, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ItemFiltersViewState();

  final List<Filter> filters;


}

class _ItemFiltersViewState extends State<ItemFiltersView> {

  late List<Filter> filters = widget.filters;
  bool? withImageCheckbox =  false;

  Widget displayFilter(Filter filter){
    return Text(filter.key!);
  }

  Widget displayFilters(List<Filter> filters){
    List<Widget> filtersWidget =  List.empty(growable: true);

    for(Filter filter in filters){
      if(filter is TextFilter){
        filtersWidget.add(
            TextFormField(
              initialValue: filter.contain,
              decoration: InputDecoration(labelText: "${filter.key} (${AppLocalizations.of(context)!.contains})"),
              onChanged: (value){
                (filters[filters.indexWhere((item) => item.key == filter.key)] as TextFilter).contain = value;
              },
            )
        );
      }
      if(filter is NumberFilter){
        filtersWidget.add(
            Row(
              children: [
                Expanded(child: NumberFormField(
                    onChanged: (value){
                      (filters[filters.indexWhere((item) => item.key == filter.key)] as NumberFilter).min = value;
                    },
                    currentValue: filter.min,
                    label:  "${filter.key} (${AppLocalizations.of(context)!.min})"
                ),),
                Expanded(child: NumberFormField(
                    onChanged: (value){
                      (filters[filters.indexWhere((item) => item.key == filter.key)] as NumberFilter).max = value;
                    },
                    currentValue: filter.max,
                    label:  "${filter.key} (${AppLocalizations.of(context)!.max})"
                ))
              ],
            )
        );
      }

      if(filter is DateFilter){
        filtersWidget.add(
            Row(
              children: [
                Expanded(child: DateFormField(
                    onChanged: (value){
                      (filters[filters.indexWhere((item) => item.key == filter.key)] as DateFilter).dateMin = value;
                    },
                    currentValue: filter.dateMin,
                    label:  "${filter.key} (${AppLocalizations.of(context)!.from})"
                ),),
                Expanded(child: DateFormField(
                    onChanged: (value){
                      (filters[filters.indexWhere((item) => item.key == filter.key)] as DateFilter).dateMax = value;
                    },
                    currentValue: filter.dateMax,
                    label:  "${filter.key} (${AppLocalizations.of(context)!.to})"
                ),)
              ],
            )
        );
      }
      if(filter is ImageFilter){
        if(filter.key == Filter.keyForAll){
          withImageCheckbox = filter.withImages ?? false;
          filtersWidget.add(
              CheckboxListTile(
                title: Text(AppLocalizations.of(context)!.onlyImages),
                value: withImageCheckbox,
                onChanged: (newValue) {
                  if(newValue == true){
                    (filters[filters.indexWhere((item) => item.key == filter.key)] as ImageFilter).withImages = newValue;
                  }else{
                    (filters[filters.indexWhere((item) => item.key == filter.key)] as ImageFilter).withImages = null;
                  }
                  setState(() {
                    withImageCheckbox = newValue;
                  });

                },
                controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
              )

          );
        }

      }
      if(filter is BoolFilter){
        filtersWidget.add(
            Row(
              children: [
                Expanded(child: CheckboxListTile(
                  title: Text("${filter.key} (${AppLocalizations.of(context)!.yes})"),
                  value: filter.trueChecked,
                  onChanged: (bool? value) {
                    BoolFilter filterOnState = (filters[filters.indexWhere((item) => item.key == filter.key)] as BoolFilter);
                    setState(() {
                      filterOnState.trueChecked = value!;

                    });
                  },
                )),
                Expanded(child: CheckboxListTile(
                  title: Text("${filter.key} (${AppLocalizations.of(context)!.no})"),
                  value: filter.falseChecked,
                  onChanged: (bool? value) {
                    BoolFilter filterOnState = (filters[filters.indexWhere((item) => item.key == filter.key)] as BoolFilter);
                    setState(() {
                      filterOnState.falseChecked = value!;

                    });
                  },
                )),
              ],
            )
        );
      }
      if(filter is TextChoiceFilter){
        List<String> choices = [...filter.choices, ""];
        filtersWidget.add(DropdownButtonFormField<String>(
            value: filter.selectedChoice ?? "",
            decoration: InputDecoration(
                labelText: "${filter.key} (Equal)",
                contentPadding: const EdgeInsets.only(top: 0, bottom: 0,left: 10)
            ),
            onChanged: (newFieldValue) {
              TextChoiceFilter filterOnState = (filters[filters.indexWhere((item) => item.key == filter.key)] as TextChoiceFilter);
              newFieldValue!.isEmpty ? filterOnState.selectedChoice = null : filterOnState.selectedChoice = newFieldValue;
            },
            items: choices.map((choice) => DropdownMenuItem<String>(child: Text(choice),value: choice)).toList()
        ));
      }
      if(filter is TextMultipleChoiceFilter){
        List<Widget> checkboxs = List.empty(growable: true);
        for(String selectedChoice in filter.choices){
          checkboxs.add(CheckboxListTile(
            title: Text(selectedChoice),
            value: filter.selectedChoices.contains(selectedChoice),
            onChanged: (bool? value) { // This is where we update the state when the checkbox is tapped
              TextMultipleChoiceFilter filterOnState = (filters[filters.indexWhere((item) => item.key == filter.key)] as TextMultipleChoiceFilter);
              bool isAlreadChecked = filterOnState.selectedChoices.contains(selectedChoice);
              setState(() {
                if(value! && !isAlreadChecked){
                  filterOnState.selectedChoices.add(selectedChoice);
                } else{
                  filterOnState.selectedChoices.remove(selectedChoice);
                }
              });
            },
          ));
        }
        filtersWidget.add(
            Card(
              elevation: 2,
              child: Column(children: [
                ListTile(title: ListTile(title: Column(children: [
                  Row(children: [
                    Text("${filter.key}"),
                    Spacer(),
                    Checkbox(
                      value: filter.enabled,
                      onChanged: (bool? value){
                        setState(() {
                          TextMultipleChoiceFilter filterOnState = (filters[filters.indexWhere((item) => item.key == filter.key)] as TextMultipleChoiceFilter);
                          filterOnState.enabled = value!;
                        });
                      },
                    )
                  ],)
                ],),),),
                filter.enabled == false ? SizedBox() :
                Column(
                  children:  checkboxs,
                )
              ],),
            )
        );
      }


      filtersWidget.add(const SizedBox(height: 10,));
    }


    return Column( children: filtersWidget);
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Stack(
          children: [
            Container(
                padding: EdgeInsets.symmetric(vertical: 40,horizontal: 30),
                child: SingleChildScrollView(
                  child: displayFilters(filters),
                )
            ),

            Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: FloatingActionButton.extended(
                      heroTag: "CLEAR",
                      onPressed: () {
                        Navigator.pop(context, Filter.clearFilters(filters));
                      },
                      label: Text(AppLocalizations.of(context)!.clear.toUpperCase())
                  ),
                )
            ),
            Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: FloatingActionButton.extended(
                    heroTag: "APPLY",
                    onPressed: () {
                      Navigator.pop(context, filters);
                    },
                    label: Text(AppLocalizations.of(context)!.applyFilters.toUpperCase())
                  ),
                )
            ),
          ],
        ),
    );
  }

}