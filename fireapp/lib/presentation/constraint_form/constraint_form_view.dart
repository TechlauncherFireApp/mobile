import 'package:fireapp/base/date_contants.dart';
import 'package:fireapp/base/widget.dart';
import 'package:fireapp/presentation/fireapp_page.dart';
import 'package:fireapp/presentation/shift_request/ShiftRequestPage.dart';
import 'package:fireapp/style/theme.dart';
import 'package:fireapp/widgets/fill_width.dart';
import 'package:fireapp/widgets/fireapp_app_bar.dart';
import 'package:fireapp/widgets/form/date_form_field.dart';
import 'package:fireapp/widgets/form/stream_form_field.dart';
import 'package:fireapp/widgets/form/time_form_field.dart';
import 'package:fireapp/widgets/scroll_view_bottom_content.dart';
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
      appBar: fireAppAppBar(context, AppLocalizations.of(context)?.schedulerTitle ?? ''),
      body: const SafeArea(
        child: SchedulerConstraintForm(),
      ),
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
    return ScrollViewBottomContent(
      padding: EdgeInsets.all(1.rdp()),
      bottomChildren: [
        SizedBox(height: 1.rdp(),),
        FillWidth(
          child: ElevatedButton(
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
        )
      ],
      children: [
        Form(
          key: viewModel.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: viewModel.titleController,
                decoration: textFieldStylePositioned(
                  context,
                ).copyWith(
                  labelText: AppLocalizations.of(context)?.scheduleName ?? "",
                ),
                style: Theme.of(context).textTheme.labelLarge,
                validator: (v) => v!.isEmpty ? 'Title is empty!' : null,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      decoration: textFieldStylePositioned(
                        context,
                      ).copyWith(
                          labelText: AppLocalizations.of(context)?.selectAsset
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
              StreamFormField<DateTime?>(
                stream: viewModel.selectedDate,
                builder: (context, value) {
                  return DateFormField(
                    currentValue: value,
                    onValueChanged: viewModel.selectDate,
                    decoration: textFieldStylePositioned(context).copyWith(
                      prefixIcon: const Icon(Icons.calendar_today),
                      labelText: AppLocalizations.of(context)?.enterDate,
                    )
                  );
                }
              ),
              StreamFormField<TimeOfDay?>(
                stream: viewModel.selectedStartTime,
                builder: (context, value) {
                  return TimeFormField(
                    currentValue: value,
                    onValueChanged: viewModel.selectStartTime,
                    decoration: textFieldStylePositioned(context).copyWith(
                      prefixIcon: const Icon(Icons.hourglass_top),
                      labelText: AppLocalizations.of(context)?.enterStartTime,
                    ),
                  );
                }
              ),
              StreamFormField<TimeOfDay?>(
                  stream: viewModel.selectedEndTime,
                  builder: (context, value) {
                    return TimeFormField(
                      currentValue: value,
                      onValueChanged: viewModel.selectEndTime,
                      decoration: textFieldStylePositioned(context).copyWith(
                        prefixIcon: const Icon(Icons.hourglass_bottom),
                        labelText: AppLocalizations.of(context)?.enterEndTime,
                      ),
                    );
                  }
              ),
            ].spacedBy(1.rdp()),
          ),
        )
      ]
    );
  }
}
