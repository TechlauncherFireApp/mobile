import 'package:fireapp/base/disposable.dart';

// This is a root class from which all ViewModels should extend
abstract class FireAppViewModel implements Disposable {
}

abstract class NavigationViewModel<T> {

  Stream<T> get navigate;

}