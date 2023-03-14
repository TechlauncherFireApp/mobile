
import 'package:flutter/cupertino.dart';

extension SpacedBy on List<Widget> {

  List<Widget> spacedBy(double space) {
    var output = <Widget>[];
    for (Widget w in this) {
      output
        ..add(w)
        ..add(SizedBox(width: space, height: space,));
    }
    output.removeLast();
    return output;
  }

}