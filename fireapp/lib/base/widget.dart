
import 'package:fireapp/base/disposable.dart';
import 'package:flutter/cupertino.dart';

abstract class FireAppState<T extends StatefulWidget> extends State<T> {}

abstract class ViewModelHolder<T> {

  late T viewModel;

}