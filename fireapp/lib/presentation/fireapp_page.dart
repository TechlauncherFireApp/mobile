
import 'package:fireapp/base/widget.dart';
import 'package:flutter/cupertino.dart';

abstract class FireAppState<T extends StatefulWidget> extends State<T> {

  @override
  void dispose() {
    super.dispose();
    if (this is ViewModelHolder) {
      (this as ViewModelHolder).viewModel.dispose();
    }
  }

}