import 'package:fireapp/presentation/change_roles/change_roles_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../base/widget.dart';
import '../fireapp_page.dart';

class ChangeRolesPage extends StatefulWidget{
  final String volunteerId;
  final List<String> roles;

  const ChangeRolesPage({
    super.key,
    required this.volunteerId,
    required this.roles,
  });

  @override
  State<StatefulWidget> createState() {
    return _ChangeRolesState();
  }

}

class _ChangeRolesState extends FireAppState<ChangeRolesPage>
implements ViewModelHolder<ChangeRolesViewModel> {

  @override
  ChangeRolesViewModel viewModel = GetIt.instance.get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Change Roles",
          style: Theme.of(context).primaryTextTheme.headline6,
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: const Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: ,
      ),
    );
  }
}