import 'package:flutter/material.dart';

/// The specific content of top navigation bar
AppBar buildTopNavBar(context) {
  return AppBar(
    title: Text(
      "FIREAPP",
      style: Theme.of(context).primaryTextTheme.headline6,
    ),
  );
}

AppBar buildTopNavBarNoLead(context) {
  return AppBar(
    title: Text(
      "FIREAPP",
      style: Theme.of(context).primaryTextTheme.headline6,
    ),
    automaticallyImplyLeading: false,
  );
}