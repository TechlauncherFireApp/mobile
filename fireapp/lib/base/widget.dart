
import 'package:fireapp/base/disposable.dart';
import 'package:fireapp/presentation/fireapp_view_model.dart';
import 'package:flutter/cupertino.dart';

abstract class ViewModelHolder<T extends FireAppViewModel> {

  late T viewModel;

}