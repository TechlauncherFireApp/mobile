import 'package:fireapp/base/widget.dart';
import 'package:fireapp/presentation/constraint_form/date_input_field.dart';
import 'package:fireapp/presentation/constraint_form/text_input_field.dart';
import 'package:fireapp/presentation/constraint_form/time_input_field.dart';
import 'package:fireapp/presentation/fireapp_page.dart';
import 'package:fireapp/style/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fireapp/presentation/constraint_form/constraint_form_view_model.dart';
import 'package:fireapp/presentation/constraint_form/base_input_field.dart';
import 'package:get_it/get_it.dart';

class SchedulerConstraintPage extends StatelessWidget {
  const SchedulerConstraintPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(AppLocalizations.of(context)?.schedulerTitle ?? '')),
      resizeToAvoidBottomInset: false,
      body: const SchedulerConstraintForm(),
    );
  }
}

class SchedulerConstraintForm extends StatefulWidget {
  const SchedulerConstraintForm({super.key});

  @override
  State createState() =>
      _SchedulerConstraintFormState();

}

class _SchedulerConstraintFormState
    extends FireAppState<SchedulerConstraintForm>
    implements ViewModelHolder<SchedulerConstraintFormViewModel> {

  @override
  SchedulerConstraintFormViewModel viewModel = GetIt.instance.get();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: viewModel.formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 1.0.rdp()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextInputField(
              controller: viewModel.titleController,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: Theme.of(context).colorScheme.shadow),
              label: AppLocalizations.of(context)?.volunteer_name ??
                  "", // This will show volunteer name
              icon: Icons.title,
              validator: (v) => v!.isEmpty ? 'Title is empty!' : null,
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelStyle: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(
                              color: Theme.of(context).colorScheme.shadow),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      prefixIcon: const Icon(Icons.arrow_drop_down),
                      labelText: AppLocalizations.of(context)?.selectAsset,
                      border: BaseInputField.commonInputBorder,
                    ),
                    value: viewModel.dropdownValue,
                    items: <int>[1, 2, 3, 4]
                        .map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(
                          'Asset $value',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .shadow), // will generate asset list in dropdown menu
                        ),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      setState(() {
                        viewModel.dropdownValue = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const Spacer(),
            SchedulerDateInputField(
              controller: viewModel.inputDateController,
              label: AppLocalizations.of(context)?.enterDate ?? "",
              icon: Icons.calendar_today,
              validator: (v) => v!.isEmpty
                  ? 'Date is empty!'
                  : null, //will return this if date is empty when submit
            ),
            const Spacer(),
            SchedulerTimeInputField(
              controller: viewModel.startTimeController,
              label: AppLocalizations.of(context)?.enterStartTime ?? "",
              icon: Icons.hourglass_top,
              validator: (v) => v!.isEmpty
                  ? 'Start Time is empty!'
                  : null, //will return this if start time is empty when submit
            ),
            const Spacer(
              flex: 45,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40),
              ),
              onPressed: viewModel.submitForm,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Add Schedule"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
