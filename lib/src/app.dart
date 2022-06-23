import 'package:my_things/src/common/common.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_things/src/common/theme/mythings/app_template_dispatcher.dart';
import 'package:my_things/src/common/theme/mythings/app_template_drawer.dart';
import 'package:my_things/src/common/theme/mythings/app_theme_data.dart';
import 'package:my_things/src/model/app_user.dart';
import 'package:my_things/src/pages/account/account_view.dart';
import 'package:my_things/src/pages/authenticate/register_view.dart';
import 'package:my_things/src/pages/authenticate/signin_view.dart';
import 'package:my_things/src/pages/collection/collections_list_view.dart';
import 'package:my_things/src/service/notifier/app_global_state.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class MyThingsAppEntrypoint extends StatelessWidget {
  const MyThingsAppEntrypoint({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AppGlobalState.instance ),
      ],
      child: const _MyThingsApp(),
    );
  }

}

class _MyThingsApp extends StatelessWidget {
  const _MyThingsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Locale local = Provider.of<AppGlobalState>(context).locale;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      /// l10n Internationalisation https://docs.flutter.dev/development/accessibility-and-localization/internationalization
      locale: local,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('fr', '')
      ],
      onGenerateRoute: (settings) {
        switch(settings.name){
          case '/':
          case '/collections':
            return NoAnimationMaterialPageRoute(builder: (_) => AuthInterceptor(CollectionListView()), settings: settings);
          case '/register':
            return NoAnimationMaterialPageRoute(builder: (_) => AuthInterceptor(RegisterView()), settings: settings);
          case '/signin':
            return NoAnimationMaterialPageRoute(builder: (_) => AuthInterceptor(SignInView()), settings: settings);
          case '/account':
            return NoAnimationMaterialPageRoute(builder: (_) => AuthInterceptor(AccountView()), settings: settings);
        }
      },
      /// named routes https://docs.flutter.dev/cookbook/navigation/named-routes
      initialRoute: '/',
      theme: AppThemeData.baseTheme,
    );
  }
}

/// this widget is used to wrap other widget who need user to be logged in routes
class AuthInterceptor extends StatelessWidget {
  const AuthInterceptor(this.destination, {Key? key}) : super(key: key);
  final Widget destination;


  @override
  Widget build(BuildContext context) {
    final AppUser? appUser = Provider.of<AppGlobalState>(context).loggedUser;
    if(appUser == null) {
      if(destination is! RegisterView && destination is! SignInView  ){
        return AppTemplateDispatcher.bottomBarTheme(SignInView());
      }
    }else{
      if(destination is RegisterView || destination is SignInView  ){
        return AppTemplateDispatcher.bottomBarTheme(CollectionListView());

      }
    }
    return AppTemplateDispatcher.bottomBarTheme(destination);
  }

}

/// Route with no animation for the NavigationBar transitions
class NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationMaterialPageRoute({ required this.builder, required this.settings })
      : super(builder: builder, settings: settings);

  WidgetBuilder builder;
  RouteSettings settings;

  @override
  Widget buildTransitions(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    
      return child;
  }
}


