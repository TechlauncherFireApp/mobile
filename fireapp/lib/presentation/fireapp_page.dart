
import 'dart:async';

import 'package:fireapp/base/widget.dart';
import 'package:fireapp/presentation/fireapp_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

abstract class FireAppState<T extends StatefulWidget> extends State<T> {

  @override
  void dispose() {
    super.dispose();
    if (this is ViewModelHolder) {
      (this as ViewModelHolder).viewModel.dispose();
    }
  }

}

mixin Navigable<NT, T extends StatefulWidget> on State<T> {

  StreamSubscription? _navigateSubscription;

  @override
  void initState() {
    super.initState();
    if (this is ViewModelHolder) {
      var vm = (this as ViewModelHolder).viewModel;
      if (vm is NavigationViewModel<NT>) {
        _navigateSubscription = (vm as NavigationViewModel<NT>).navigate.listen((event) {
          handleNavigationEvent(event);
        });
      }
    }
  }

  void handleNavigationEvent(NT event);

  @override
  void dispose() {
    super.dispose();
    _navigateSubscription?.cancel();
  }

}