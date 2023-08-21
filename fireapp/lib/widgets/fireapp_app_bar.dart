
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget fireAppAppBar(BuildContext context, String title) {
  return AppBar(
    title: Text(title),
    elevation: 1,
    backgroundColor: Theme.of(context).colorScheme.surface,
    foregroundColor: Theme.of(context).colorScheme.onSurface,
    iconTheme: IconThemeData(
      color: Theme.of(context).colorScheme.primary
    ),
    toolbarHeight: 65,
  );
}

PreferredSizeWidget fireAppSearchBar(BuildContext context, String title, Function(String) onSearch) {
  return EasySearchBar(
    title: Text(title),
    onSearch: onSearch,
    elevation: 1,
    backgroundColor: Theme.of(context).colorScheme.surface,
    foregroundColor: Theme.of(context).colorScheme.onSurface,
    iconTheme: IconThemeData(
        color: Theme.of(context).colorScheme.primary
    ),
    appBarHeight: 65,
  );
}