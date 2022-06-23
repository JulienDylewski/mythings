import 'package:my_things/src/common/common.dart';
import 'package:my_things/src/model/collection.dart';
import 'package:my_things/src/model/filters.dart';
import 'package:my_things/src/pages/item/item_add_view.dart';
import 'package:my_things/src/pages/item/item_list_view_model.dart';
import 'package:my_things/src/service/backend/database_item_service.dart';
import 'package:provider/provider.dart';

import 'item_filters_view.dart';
import 'item_list_view.dart';


class ItemsView extends StatelessWidget {
  const ItemsView({Key? key, required this.collection}) : super(key: key);
  final Collection collection;


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: ItemListViewModel.instance,
        child: _CollectionItemListPopupView(collection: collection)
    );
  }
}

class _CollectionItemListPopupView extends StatefulWidget{
  const _CollectionItemListPopupView({Key? key, required this.collection}) : super(key: key);
  final Collection collection;

  @override
  State<StatefulWidget> createState() => _CollectionItemListPopupViewState();

}
class _CollectionItemListPopupViewState extends State<_CollectionItemListPopupView>{
  bool _collectionItemsLoaded = false;
  late ItemListViewModel viewModel;
  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<ItemListViewModel>(context, listen: false);
    viewModel.setEmptyFiltersWithCollectionFields(widget.collection.fields);
    DatabaseItemService.instance.getItems(collectionRef: widget.collection.docRef!)
        .then((collectionItems) {
      viewModel.setCollectionItems(collectionItems!);
      setState(() {
        _collectionItemsLoaded = true;
      });
    })
        .catchError((err) {
      setState(() {
        _collectionItemsLoaded = true;
      });
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.collection.name),),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: _collectionItemsLoaded ? ItemListView(collection: widget.collection) : Center(child: CircularProgressIndicator()),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: FloatingActionButton(
                backgroundColor: Colors.teal,
                onPressed: () {
                  Navigator.push(context,  MaterialPageRoute(
                      builder: (context) => ItemAddPopUpView(collection: widget.collection)));
                },
                child: const Icon(Icons.add, size: 30, ),
              ),
            )
          ),
          // Align(
          //     alignment: Alignment.bottomLeft,
          //     child: Container(
          //       padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          //       child: IconButton(
          //         onPressed: () {
          //
          //         },
          //         icon: Icon(Icons.swap_vert, size: 30,),
          //       ),
          //     )
          // ),
          Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child:  FloatingActionButton(
                  heroTag: "SEARCH",
                  backgroundColor: Colors.teal,
                  onPressed: () {
                    Navigator.push(context,  MaterialPageRoute(
                        builder: (context) => ItemFiltersView(viewModel.filters)))
                    .then((value) {
                      if(value is List<Filter>){
                        viewModel.setFilters(value);
                        viewModel.applyFilters();
                      }

                    });
                  },
                  child: Icon(Icons.search),
                ),
              )
          )
        ],
      ),
    );
  }

}

