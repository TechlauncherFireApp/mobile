import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fireapp/presentation/constraint_form/constraint_form_view_model.dart';

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
              controller: viewModel.titleController,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: Colors.grey[700]),
              label: AppLocalizations.of(context)?.volunteer_name ?? "", // This will show volunteer name
              icon: Icons.title,
              validator: (v) => v!.isEmpty ? 'Title is empty!' : null,
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
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                  color: Colors
                                      .grey[700]), // will generate asset list in dropdown menu
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
              controller: viewModel.inputDateController,
              label: AppLocalizations.of(context)?.enterDate ?? "",
              icon: Icons.calendar_today,
              validator: (v) => v!.isEmpty ? 'Date is empty!' : null, //will return this if date is empty when submit
            ),
            const SizedBox(
              height: 2.0,
            ),
            _SchedulerTimeInput(
              controller: viewModel.startTimeController,
              label: AppLocalizations.of(context)?.enterStartTime ?? "",
              icon: Icons.hourglass_top,
              validator: (v) => v!.isEmpty ? 'Start Time is empty!' : null, //will return this if start time is empty when submit
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

class _SchedulerInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?)? validator;

  const _SchedulerInputField({
    required this.controller,
    required this.label,
    required this.icon,
    this.validator,
    TextStyle? style,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: Theme.of(context).textTheme.labelLarge, // using the same text theme from login_page
      decoration: InputDecoration(
        labelStyle: Theme.of(context).textTheme.labelLarge, // using the same text theme from login_page
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon),
        labelText: label,
        border: commonInputBorder
      ),
      validator: validator,
    );
  }
}

class _SchedulerDateInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?)? validator;

  const _SchedulerDateInput({
    required this.controller,
    required this.label,
    required this.icon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: Theme.of(context).textTheme.labelLarge, // using the same text theme from login_page
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)?.enterDate,
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
}

class _SchedulerTimeInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextStyle? style;

  const _SchedulerTimeInput({
    required this.controller,
    required this.label,
    required this.icon,
    this.validator,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: style ?? Theme.of(context).textTheme.labelLarge,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)?.enterStartTime,
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
  }
}

var commonInputBorder =  const OutlineInputBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(5.0),
        topRight: Radius.circular(5.0), // same radius circular as login_page
      ),
    );

