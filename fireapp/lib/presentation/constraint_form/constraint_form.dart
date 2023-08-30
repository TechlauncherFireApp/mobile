import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fireapp/presentation/constraint_form/constraint_form_view_model.dart';

enum schedulerInputType { text, date, time }

class ConstraintFormRoute extends StatelessWidget {
  const ConstraintFormRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scheduler')),
      resizeToAvoidBottomInset: false,
      body: const ConstraintForm(),
    );
  }
}

class ConstraintForm extends StatefulWidget {
  const ConstraintForm({super.key});

  @override
  _ConstraintFormState createState() => _ConstraintFormState();
}

class _ConstraintFormState extends State<ConstraintForm> {
  final viewModel = ConstraintFormViewModel();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: viewModel.formKey,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SchedulerInputField(
              viewModel.titleController,
               Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: Colors.grey[700]),
              AppLocalizations.of(context)?.volunteer_name ??
                  "", // This will show volunteer name
              Icons.title,
              (v) => v!.isEmpty ? 'Title is empty!' : null,
            ),
            const SizedBox(height: 2.0),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelStyle: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(color: Colors.grey[700]),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.arrow_drop_down),
                      labelText: AppLocalizations.of(context)?.selectAsset,
                      border: commonInputBorder,
                    ),
                    value: viewModel.dropdownValue,
                    items: <int>[1, 2, 3, 4]
                        .map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(
                          'Asset $value',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Colors.grey[
                                  700]), // will generate asset list in dropdown menu
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
            const SizedBox(
              height: 2.0,
            ),
            _SchedulerDateInput(
              viewModel.inputDateController,
              AppLocalizations.of(context)?.enterDate ?? "",
              Icons.calendar_today,
              (v) => v!.isEmpty
                  ? 'Date is empty!'
                  : null, //will return this if date is empty when submit
            ),
            const SizedBox(
              height: 2.0,
            ),
            _SchedulerTimeInput(
              viewModel.startTimeController,
              AppLocalizations.of(context)?.enterStartTime ?? "",
              Icons.hourglass_top,
              (v) => v!.isEmpty
                  ? 'Start Time is empty!'
                  : null, //will return this if start time is empty when submit
            ),
            const SizedBox(
              height: 420.0,
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

class _SchedulerInputField extends _BaseInputField {
  const _SchedulerInputField(
      TextEditingController controller,
      TextStyle? style,
      String label,
      IconData icon,
      String? Function(String?)? validator,) : super(
    controller: controller,
    style: style,
    label: label,
    icon: icon,
    validator: validator,
    inputType: schedulerInputType.text,
  );
}

class _SchedulerDateInput extends _BaseInputField {
  const _SchedulerDateInput(
  TextEditingController controller,
      String label,
      IconData icon,
      String? Function(String?)? validator,
      ): super(
    controller: controller,
    label: label,
    icon: icon,
    validator: validator,
    inputType: schedulerInputType.date,
  );
}

class _SchedulerTimeInput extends _BaseInputField {
  const _SchedulerTimeInput(
      TextEditingController controller,
      String label,
      IconData icon,
      String? Function(String?)? validator,
      ): super(
    controller: controller,
    label: label,
    icon: icon,
    validator: validator,
    inputType: schedulerInputType.time,
  );

}

var commonInputBorder = const OutlineInputBorder(
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(5.0),
    topRight: Radius.circular(5.0), // same radius circular as login_page
  ),
);


class _BaseInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextStyle? style;
  final schedulerInputType inputType;

  const _BaseInputField({
    required this.controller,
    required this.label,
    required this.icon,
    this.validator,
    this.style,
    required this.inputType,
  });

  @override
  Widget build(BuildContext context) {
    switch (inputType) {
      case schedulerInputType.text:
        {
          return TextFormField(
            controller: controller,
            style: Theme
                .of(context)
                .textTheme
                .labelLarge, // using the same text theme from login_page
            decoration: InputDecoration(
                labelStyle: Theme
                    .of(context)
                    .textTheme
                    .labelLarge,
                // using the same text theme from login_page
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(icon),
                labelText: label,
                border: commonInputBorder),
            validator: validator,
          );
          // statements;
        }
      case schedulerInputType.date:
        {
          return TextFormField(
            controller: controller,
            style: Theme
                .of(context)
                .textTheme
                .labelLarge,
            // using the same text theme from login_page
            decoration: InputDecoration(
              labelText: AppLocalizations
                  .of(context)
                  ?.enterDate,
              fillColor: Colors.white,
              filled: true,
              prefixIcon: const Icon(Icons.calendar_today),
              border: commonInputBorder,
            ),
            readOnly: true,
            validator: validator,
            onTap: () async {
              DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              );
              if (selectedDate != null) {
                controller.text = DateFormat('yyyy-MM-dd').format(selectedDate);
              }
            },
          );
        }
      case schedulerInputType.time:
        {
          return TextFormField(
            controller: controller,
            style: style ?? Theme
                .of(context)
                .textTheme
                .labelLarge,
            decoration: InputDecoration(
              labelText: AppLocalizations
                  .of(context)
                  ?.enterStartTime,
              fillColor: Colors.white,
              filled: true,
              prefixIcon: Icon(icon),
              border: commonInputBorder,
            ),
            readOnly: true,
            validator: validator,
            onTap: () async {
              TimeOfDay? selectedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (selectedTime != null) {
                controller.text = selectedTime.format(context);
              }
            },
          );
          //statements;
        }
    }
  }
}
