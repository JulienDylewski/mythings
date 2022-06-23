import 'package:flutter/material.dart';
import 'package:my_things/src/model/collection.dart';
import 'package:my_things/src/pages/collection/collection_add_view.dart';
import 'package:my_things/src/pages/collection/collection_edit_view.dart';
import 'package:my_things/src/pages/collection/collections_list_view_model.dart';
import 'package:my_things/src/components/image_box/image_box_view.dart';
import 'package:my_things/src/pages/item/items_view.dart';
import 'package:my_things/src/service/backend/database_collection_service.dart';
import 'package:my_things/src/service/frontend/dialog_service.dart';
import 'package:provider/provider.dart';
import 'package:my_things/src/common/common.dart';

class CollectionListView extends StatelessWidget {
  const CollectionListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value:  CollectionsListViewModel.instance ,
        child: const _CollectionListView()
    );
  }
}

class _CollectionListView extends StatefulWidget {
  const _CollectionListView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CollectionListViewState();
}


class _CollectionListViewState extends State<_CollectionListView> {
  bool _collectionLoaded = false;
  late final  DialogService       _dialogService = DialogService(context);

  //TODO: Bad render image when create / edit image
  Widget getCollections(List<Collection> collections, BuildContext context)  {
    CollectionsListViewModel viewModel = Provider.of<CollectionsListViewModel>(context, listen: false);
    List<Widget> list = List<Widget>.empty(growable: true);

    for (var collection in collections) {
      var card  = Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        elevation: 5,
        margin: const EdgeInsets.all(5),
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          children: [
             ListTile(
                title: Row(
                  children: <Widget>[
                    Expanded(child: Text(collection.name)),

                    IconButton(
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CollectionEditView(collection: collection),
                            )
                          );
                        },
                        icon: const Icon(Icons.edit)
                    ),
                  ],
                ),

             ),
            GestureDetector(
              child:   ImageBoxView.network(collection.image.safeDownloadUrl, 200),
              onTap: () {
                Navigator.push(context,  MaterialPageRoute(builder: (context) => ItemsView(collection: collection)));
              },
              behavior: HitTestBehavior.translucent,
            )

          ],
        ),
      );
      list.add(card);
    }
    return Column(children: list);
  }

  @override
  void initState() {
    super.initState();

    CollectionsListViewModel viewModel = Provider.of<CollectionsListViewModel>(context, listen: false);
    DatabaseCollectionService.instance.getAll().then( (collections) {
      viewModel.setCollection(collections);
      if(mounted){
        setState(() {
          _collectionLoaded = true;
        });
      }

    }).catchError((e) {
      if(mounted){
        setState(() {
          _collectionLoaded = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    CollectionsListViewModel viewModel = Provider.of<CollectionsListViewModel>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, size: 30, ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CollectionAddView(),
            )
          );
        },
      ),
      body: Container(
        child: SingleChildScrollView(child:Column(
          children: [
            _collectionLoaded ?  getCollections(viewModel.collections, context) : const Center(child: CircularProgressIndicator(),)
          ],
        ),
      ),

    ));
  }
}