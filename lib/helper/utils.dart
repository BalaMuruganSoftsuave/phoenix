
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:phoenix/helper/nav_observer.dart';

///hide keyboard in iOS
void hideKeyboard(BuildContext buildContext) {
  FocusScopeNode currentFocus = FocusScope.of(buildContext);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}

///get current context
BuildContext? getCtx([BuildContext? context]) =>
    NavObserver.navKey.currentContext ?? context;

///get text theme from material
TextTheme getTextTheme() => Theme.of(getCtx()!).textTheme;

translate(String text) {
  return getCtx()?.tr(text);
}
