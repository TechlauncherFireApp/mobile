import 'package:flutter/material.dart';
import 'appbar.dart';

/// The class is to wrap the page with navbar
/// Generate a file generated_plugin_registrant.dart in lib
///
/// Also, if there exists some public area, add it here
class BasicWrapper extends StatelessWidget {
  const BasicWrapper({Key? key, required this.page}) : super(key: key);

  final Widget page;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Add the top navbar
      appBar: buildTopNavBar(context),
      resizeToAvoidBottomInset: false,
      body: SafeArea(child: page),
    );
  }
}

class BasicWrapperNoLead extends StatelessWidget {
  const BasicWrapperNoLead({Key? key, required this.page}) : super(key: key);

  final Widget page;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Add the top navbar
      appBar: buildTopNavBarNoLead(context),
      resizeToAvoidBottomInset: false,
      body: SafeArea(child: page),
    );
  }
}