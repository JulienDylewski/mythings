import 'package:my_things/src/common/common.dart';
import 'package:my_things/src/common/theme/mythings/app_global_loading.dart';
import 'package:my_things/src/common/theme/mythings/app_template_view_model.dart';
import 'package:my_things/src/service/notifier/app_global_state.dart';
import 'package:provider/provider.dart';
import 'app_template_view_model.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// App Template with bottom button navigation
class AppTemplateBottomBar extends StatelessWidget{
  const AppTemplateBottomBar(this.bodyWidget, {Key? key}) : super(key: key);
  final Widget bodyWidget;

  @override
  Widget build(BuildContext context) {
    /// App Global Notifier for AppGlobalState
    return ChangeNotifierProvider(
        create: (context) => AppTemplateViewModel(context),
        child: _AppTemplateBottomBar(bodyWidget)
    );
  }
}

class _AppTemplateBottomBar extends StatefulWidget {
  const _AppTemplateBottomBar(this.bodyWidget, {Key? key}) : super(key: key);
  final Widget bodyWidget;

  @override
  State<_AppTemplateBottomBar> createState() => _AppTemplateBottomBarState();
}

class _AppTemplateBottomBarState extends State<_AppTemplateBottomBar> {
  int    selectedIndex = 1;


  List<BottomNavigationBarItem> _buildBottomBarItems(AppGlobalState appGlobalState, AppLocalizations localizations){
    List<BottomNavigationBarItem> bottomItems = List.empty(growable: true);
    BottomNavigationBarItem traductions = BottomNavigationBarItem(
        icon: appGlobalState.locale.languageCode == 'fr'
            ? SvgPicture.asset('assets/fr.svg', height: 20, width: 20)
            : SvgPicture.asset('assets/gb.svg', height: 16, width: 16),
        label: localizations.language
    );

    if(appGlobalState.loggedUser == null){
      bottomItems.add(BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: localizations.login));
      bottomItems.add(BottomNavigationBarItem(icon: Icon(Icons.person_add), label: localizations.createAnAccount));
    }else{
      bottomItems.add(BottomNavigationBarItem(icon: Icon(Icons.library_books), label: localizations.collections));
      bottomItems.add(BottomNavigationBarItem(icon: Icon(Icons.account_box) , label: localizations.userProfil));
    }
    bottomItems.add(traductions);

    return bottomItems;
  }

  _bottomNavigationTapped(int index, AppGlobalState appGlobalState){
    if(appGlobalState.loggedUser == null){
      switch(index){
        case 0:
          Navigator.pushReplacementNamed(context, '/signin');
          break;
        case 1:
          Navigator.pushReplacementNamed(context, '/register');
          break;
        case 2:
          appGlobalState.setLocale(
              appGlobalState.locale.languageCode == 'fr'
                  ? const Locale.fromSubtags(languageCode: 'en')
                  : const Locale.fromSubtags(languageCode: 'fr')
          );
      }
    }else{
      switch(index){
        case 0:
          Navigator.pushReplacementNamed(context, '/collections');
          break;
        case 1:
          Navigator.pushReplacementNamed(context, '/account');
          break;
        case 2:
          appGlobalState.setLocale(
              appGlobalState.locale.languageCode == 'fr'
                  ? const Locale.fromSubtags(languageCode: 'en')
                  : const Locale.fromSubtags(languageCode: 'fr')
          );

      }
    }

  }

  @override
  Widget build(BuildContext context) {
    final AppGlobalState appGlobalState = Provider.of<AppGlobalState>(context);
    final AppTemplateViewModel  viewModel = Provider.of<AppTemplateViewModel>(context);
    final AppLocalizations localizations =   AppLocalizations.of(context)!;


    switch(ModalRoute.of(context)!.settings.name){
      case '/':
      case '/collections':
      case '/signin':
        selectedIndex = 0;
        break;
      case '/register':
      case '/account':
        selectedIndex = 1;


    }

    /// La Stack permet l'affichage d'element empilés, ici nous permet d'afficher le global loader au dessus de l'ui
    return Stack(
      children: [
        /// Main Layout
        Scaffold(
          body: Container(
            padding: EdgeInsets.only(top: 30, bottom: 10, left: 10, right: 10),
            child: widget.bodyWidget,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: selectedIndex,
            items: _buildBottomBarItems(appGlobalState, localizations),
            onTap: (index) => _bottomNavigationTapped(index, appGlobalState),
          ),
        ),
        /// Global Loader
        appGlobalState.appGlobalLoading ? const AppGlobalLoading() : const SizedBox(width: 0, height: 0,)
      ],
    ) ;
  }
}

