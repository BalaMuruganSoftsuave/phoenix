import 'package:flutter/cupertino.dart';

import 'nav_observer.dart';

BuildContext? getCtx([BuildContext? context]) =>
    NavObserver.navKey.currentContext ?? context;