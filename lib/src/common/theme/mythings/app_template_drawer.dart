import 'package:my_things/src/common/common.dart';
import 'package:my_things/src/common/theme/mythings/app_global_loading.dart';
import 'package:my_things/src/common/theme/mythings/app_template_view_model.dart';
import 'package:my_things/src/model/app_user.dart';
import 'package:my_things/src/service/notifier/app_global_state.dart';
import 'package:provider/provider.dart';
import 'app_template_view_model.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// AppTemplate with drawer navigation
class AppTemplateDrawer extends StatelessWidget{
  const AppTemplateDrawer(this._bodyWidget, {Key? key}) : super(key: key);
  final Widget _bodyWidget;


  @override
  Widget build(BuildContext context) {
    /// App Global Notifier for AppGlobalState
    return ChangeNotifierProvider(
        create: (context) => AppTemplateViewModel(context),
        child: _AppTemplateDrawer(_bodyWidget)
    );
  }
}

class _AppTemplateDrawer extends StatefulWidget {
  const _AppTemplateDrawer(this.bodyWidget, {Key? key}) : super(key: key);
  final Widget bodyWidget;

  @override
  State<_AppTemplateDrawer> createState() => _AppTemplateDrawerState();
}

class _AppTemplateDrawerState extends State<_AppTemplateDrawer> {
  String selectedLanguage = AppGlobalState.instance.locale.languageCode;

  /// Menu burger
  Drawer? appDrawer(AppUser? appUser, AppTemplateViewModel viewModel, BuildContext context) {
    List<Widget> drawerItems = List.empty(growable: true);

    if(appUser == null){
      drawerItems.add(const DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.teal,
        ),
        child: Center(
          child: Text("", style: TextStyle(color: Colors.white)),
        ),
      ));
      drawerItems.add(ListTile(
        tileColor: Colors.black.withOpacity(0.05),
        title: Text(AppLocalizations.of(context)!.login),
        onTap: () {
          Navigator.pushReplacementNamed(context, '/signin');
        },
      ));
      drawerItems.add(ListTile(
        tileColor: Colors.black.withOpacity(0.05),
        title: Text(AppLocalizations.of(context)!.createAnAccount),
        onTap: () {
          Navigator.pushReplacementNamed(context, '/register');
        },
      ));
    }else{
      drawerItems.add(DrawerHeader(
        decoration: const BoxDecoration(
          color: Colors.teal,
        ),
        child: Center(
          child: Text("${AppLocalizations.of(context)!.username} : ${appUser.username} (${appUser.email})", style: const TextStyle(color: Colors.white)),
        ),
      ));
      drawerItems.add(ListTile(
        tileColor: Colors.black.withOpacity(0.05),
        title: Text(AppLocalizations.of(context)!.collections),
        onTap: () {
          Navigator.pushReplacementNamed(context, '/collections');
        },
      ));
      drawerItems.add(ListTile(
        tileColor: Colors.black.withOpacity(0.05),
        title: Text(AppLocalizations.of(context)!.userProfil),
        onTap: () {
          Navigator.pushReplacementNamed(context, '/account');
        },
      ));
      drawerItems.add(ListTile(
        tileColor: Colors.black.withOpacity(0.05),
        title: Text(AppLocalizations.of(context)!.logout),
        onTap: () {
          viewModel.signOut();
        },
      ));
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: drawerItems,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppGlobalState appGlobalState = Provider.of<AppGlobalState>(context);
    final AppTemplateViewModel  viewModel = Provider.of<AppTemplateViewModel>(context);

    /// La Stack permet l'affichage d'element empilés, ici nous permet d'afficher le global loader au dessus de l'ui
    return Stack(
      children: [
        /// Main Layout
        Scaffold(
          body: widget.bodyWidget,
          drawer: appDrawer(appGlobalState.loggedUser, viewModel, context),
          appBar: AppBar(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                /// Choix de langue
                DropdownButton<String>(
                  value: selectedLanguage,
                  icon: const Icon(Icons.arrow_downward, color: Colors.white),
                  elevation: 16,
                  style: const TextStyle(color: Colors.black),
                  onChanged: (String? newValue) {
                    setState(() {
                      appGlobalState.setLocale(Locale.fromSubtags(languageCode: newValue!));
                      selectedLanguage = newValue;
                    });
                  },
                  items: <String>['fr', 'en']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: value == 'fr'
                          ? SvgPicture.asset('assets/fr.svg', height: 20, width: 20)
                          : SvgPicture.asset('assets/gb.svg', height: 16, width: 16),
                    );
                  }).toList(),
                ),

              ],
            ),

          ),
        ),
        /// Global Loader
        appGlobalState.appGlobalLoading ? const AppGlobalLoading() : const SizedBox(width: 0, height: 0,)
      ],
    ) ;
  }
}

