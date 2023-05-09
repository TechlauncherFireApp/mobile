import 'package:fireapp/domain/models/reference/qualification.dart';
import 'package:fireapp/presentation/change_roles/change_roles_view_model.dart';
import 'package:fireapp/presentation/change_roles/change_roles_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../base/widget.dart';
import '../fireapp_page.dart';
import 'change_qualifications_widget.dart';

class ChangeQualificationsPage extends StatefulWidget{
  final String volunteerId;
  final List<Qualification> qualifications;

  const ChangeQualificationsPage({
    super.key,
    required this.volunteerId,
    required this.qualifications,
  });

  @override
  State<StatefulWidget> createState() {
    return _ChangeQualificationState();
  }

}

class _ChangeQualificationState extends FireAppState<ChangeQualificationsPage>
implements ViewModelHolder<ChangeRolesViewModel> {

  @override
  ChangeRolesViewModel viewModel = GetIt.instance.get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Change Qualifications",
          style: Theme.of(context).primaryTextTheme.headline6,
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: ChangeQualificationsWidget(volunteerId: widget.volunteerId,qualifications: widget.qualifications),
      ),
    );
  }
}