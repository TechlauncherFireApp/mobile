
import 'package:flutter/material.dart';

class ScrollViewBottomContent extends StatelessWidget {

  final List<Widget> children;
  final List<Widget> bottomChildren;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final VerticalDirection verticalDirection;
  final EdgeInsetsGeometry padding;

  const ScrollViewBottomContent({
    super.key,
    required this.children,
    required this.bottomChildren,
    CrossAxisAlignment? crossAxisAlignment,
    MainAxisAlignment? mainAxisAlignment,
    VerticalDirection? verticalDirection,
    EdgeInsetsGeometry? padding
  }) : crossAxisAlignment = crossAxisAlignment ?? CrossAxisAlignment.start,
       mainAxisAlignment = mainAxisAlignment ?? MainAxisAlignment.start,
       verticalDirection = verticalDirection ?? VerticalDirection.down,
       padding = padding ?? EdgeInsets.zero;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: padding,
                child: Column(
                  crossAxisAlignment: crossAxisAlignment,
                  mainAxisAlignment: mainAxisAlignment,
                  verticalDirection: verticalDirection,
                  children: <Widget>[
                    ...children,
                    Expanded(
                      child: Container(),
                    ),
                    ...bottomChildren,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}