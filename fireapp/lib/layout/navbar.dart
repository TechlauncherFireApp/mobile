import 'package:flutter/material.dart';

/// The specific content of top navigation bar
AppBar buildTopNavBar(context) {
  return AppBar(
    leading: const IconButton(
      icon: Icon(Icons.menu),
      tooltip: 'Navigation menu',
      onPressed: null, // null disables the button
    ),
    title: Text(
      "FIREAPP",
      style: Theme.of(context).primaryTextTheme.headline6,
    ),
    actions: const [
      IconButton(
        icon: Icon(Icons.search),
        tooltip: 'Search',
        onPressed: null,
      )
    ],
  );
}