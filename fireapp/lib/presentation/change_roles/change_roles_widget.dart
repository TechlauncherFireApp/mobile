import 'package:fireapp/presentation/change_roles/change_roles_option_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

import '../../widgets/request_state_widget.dart';
import '../fireapp_page.dart';
import 'change_roles_view_model.dart';

class ChangeRolesWidget extends StatefulWidget {

  const ChangeRolesWidget({super.key});

  @override
  State createState() => _ChangeRolesWidgetState();

}

class _ChangeRolesWidgetState extends FireAppState<ChangeRolesWidget>{

  @override
  ChangeRolesViewModel viewModel = GetIt.instance.get();

  @override
  Widget build(BuildContext context) {
    return RequestStateWidget.stream<List<UserRole>>(
        state: viewModel.userRoles,
        retry: () { viewModel.load(); },
        child: (_, roles) {
          return RequestStateWidget.stream<void>(
              state: viewModel.submissionState,
              retry: () { viewModel.submit(); },
              child: (_, __) {
                return Column(
                  children: [
                    Column(
                      children: restrictions.restrictions
                          .map((e) => _restriction(e))
                          .toList()
                          .spacedBy(0),
                    ),
                    Column(
                      children: [
                        Text(
                          AppLocalizations.of(context)?.dietaryRequirementsCustomTitle ?? "",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: viewModel.customRestrictions,
                        )
                      ].spacedBy(8),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50)
                      ),
                      onPressed: () => viewModel.submit(),
                      child: const Text("Submit"),
                    )
                  ].spacedBy(16),
                );
              }
          );
        }
    );
  }
}