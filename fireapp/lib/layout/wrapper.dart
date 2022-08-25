import 'package:flutter/material.dart';
import 'navbar.dart';

class BasicWrapper extends StatelessWidget {
  const BasicWrapper({Key? key, required this.page}) : super(key: key);

  final Widget page;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildTopNavBar(context),
      resizeToAvoidBottomInset: false,
      body: SafeArea(child: page),
    );
  }
}