
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:phoenix/helper/nav_observer.dart';

import 'dependency.dart';

///hide keyboard in iOS
void hideKeyboard(BuildContext buildContext) {
  FocusScopeNode currentFocus = FocusScope.of(buildContext);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}

// ///get current context
// BuildContext? getCtx([BuildContext? context]) =>
//     NavObserver.navKey.currentContext ?? context;

///get text theme from material
TextTheme getTextTheme() => Theme.of(getCtx()!).textTheme;

translate(String text) {
  return getCtx()?.tr(text);
}
/// Extension on [Iterable] to provide additional functionality.
/// Extension on [Iterable] to provide additional functionality.
extension IterableExtension<T> on Iterable<T> {
  /// Returns the first element of the iterable that satisfies the provided predicate function.
  ///
  /// If no element satisfies the predicate, returns `null`.
  ///
  /// - [isTrue]: A function that takes an element of type `T` and returns a boolean value.
  ///
  /// Example:
  ///
  /// ```dart
  /// final list = [1, 2, 3, 4, 5];
  /// final result = list.firstWhereOrNull((element) => element > 3);
  /// print(result); // Output: 4
  /// ```
  T? firstWhereOrNull(bool Function(T val) isTrue) {
    for (final e in this) {
      if (isTrue(e)) {
        return e;
      }
    }
    return null;
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  //to change text to titlecase
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}