import 'package:flutter/material.dart';
import 'package:my_things/src/common/theme/mythings/app_template_bottombar.dart';
import 'package:my_things/src/common/theme/mythings/app_template_drawer.dart';

class AppTemplateDispatcher extends StatelessWidget{
  const AppTemplateDispatcher(this.bodyWidget, {Key? key}) : super(key: key);
  final Widget bodyWidget;

  factory AppTemplateDispatcher.bottomBarTheme(Widget body) => AppTemplateDispatcher(AppTemplateBottomBar(body));
  factory AppTemplateDispatcher.drawerViewTheme(Widget body) => AppTemplateDispatcher(AppTemplateDrawer(body));

  @override
  Widget build(BuildContext context) {
    return bodyWidget;
  }
}