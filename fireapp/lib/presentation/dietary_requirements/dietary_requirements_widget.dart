
import 'package:fireapp/base/spaced_by.dart';
import 'package:fireapp/base/widget.dart';
import 'package:fireapp/presentation/dietary_requirements/dietary_requirements_presentation_model.dart';
import 'package:fireapp/presentation/dietary_requirements/dietary_requirements_view_model.dart';
import 'package:fireapp/presentation/fireapp_page.dart';
import 'package:fireapp/widgets/request_state_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DietaryRequirementsWidget extends StatefulWidget {

  const DietaryRequirementsWidget({super.key});

  @override
  State createState() => _DietaryRequirementsWidgetState();

}

class _DietaryRequirementsWidgetState extends FireAppState<DietaryRequirementsWidget>
    implements ViewModelHolder<DietaryRequirementsViewModel> {

  @override
  DietaryRequirementsViewModel viewModel = GetIt.instance.get();

  @override
  void initState() {
    super.initState();
    viewModel.load();
  }

  @override
  Widget build(BuildContext context) {
    return RequestStateWidget.stream<UserDietaryRequirements>(
      state: viewModel.requirements,
      retry: () { viewModel.load(); },
      child: (_, restrictions) {
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

  Widget _restriction(UserDietaryRestriction restriction) {
    return Row(
      children: [
        Checkbox(
          value: restriction.checked,
          onChanged: (v) => viewModel.updateRequirement(restriction.restriction, !restriction.checked)
        ),
        Text(restriction.restriction.displayName)
      ].spacedBy(8),
    );
  }

}