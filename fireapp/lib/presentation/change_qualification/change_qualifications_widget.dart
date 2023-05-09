import 'package:fireapp/base/spaced_by.dart';
import 'package:fireapp/domain/models/reference/qualification.dart';
import 'package:fireapp/presentation/change_qualification/change_qualification_option_model.dart';
import 'package:fireapp/presentation/change_roles/change_roles_option_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../base/widget.dart';
import '../../widgets/request_state_widget.dart';
import '../fireapp_page.dart';
import 'change_qualification_view_model.dart';

class ChangeQualificationsWidget extends StatefulWidget {
  final String volunteerId;
  final List<Qualification> qualifications;
  const ChangeQualificationsWidget({super.key, required this.volunteerId, required this.qualifications});

  @override
  State createState() => _ChangeQualificationsWidgetState();

}

class _ChangeQualificationsWidgetState extends FireAppState<ChangeQualificationsWidget>
  implements ViewModelHolder<ChangeQualificationsViewModel> {

  @override
  ChangeQualificationsViewModel viewModel = GetIt.instance.get();

  @override
  void initState() {
    super.initState();
    viewModel.init(widget.volunteerId, widget.qualifications);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel.init(widget.volunteerId, widget.qualifications);
  }

  @override
  Widget build(BuildContext context) {
    return RequestStateWidget.stream<List<UserQualification>>(
        state: viewModel.userQualifications,
        retry: () { viewModel.load(); },
        child: (_, qualifications) {
          return RequestStateWidget.stream<void>(
              state: viewModel.submissionState,
              retry: () { viewModel.load(); },
              child: (_, __) {
                return Column(
                  children: [
                    Column(
                      children: qualifications
                          .map((e) => _qualification(e))
                          .toList()
                          .spacedBy(0),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50)
                      ),
                      onPressed: () => viewModel.load(),
                      child: const Text("Submit"),
                    )
                  ].spacedBy(16),
                );
              }
          );
        }
    );
  }

  Widget _qualification(UserQualification qualification) {
    return Row(
      children: [
        Checkbox(
            value: qualification.checked,
            onChanged: (v) => viewModel.updateQualification(qualification)
        ),
        Text(qualification.qualification.name)
      ].spacedBy(8),
    );
  }
}