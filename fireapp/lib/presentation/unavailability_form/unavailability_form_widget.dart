import 'package:fireapp/base/spaced_by.dart';
import 'package:fireapp/base/widget.dart';
import 'package:fireapp/domain/models/unavailability/unavailability_time.dart';
import 'package:fireapp/presentation/unavailability_form/unavailability_form_view_model.dart';
import 'package:fireapp/presentation/unavailability_form/unavailability_form_navigation.dart';
import 'package:fireapp/presentation/fireapp_page.dart';
import 'package:fireapp/style/theme.dart';
import 'package:fireapp/widgets/fill_width.dart';
import 'package:fireapp/widgets/fireapp_app_bar.dart';
import 'package:fireapp/widgets/form/date_form_field.dart';
import 'package:fireapp/widgets/form/stream_form_field.dart';
import 'package:fireapp/widgets/form/time_form_field.dart';
import 'package:fireapp/widgets/scroll_view_bottom_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import '../../domain/request_state.dart';

class UnavailabilityFormPage extends StatefulWidget {
  final UnavailabilityTime event;
  const UnavailabilityFormPage({super.key, required this.event});

  @override
  State createState() => _UnavailabilityFormState();
}

class _UnavailabilityFormState extends FireAppState<UnavailabilityFormPage>
    with Navigable<UnavailabilityFormNavigation, UnavailabilityFormPage>
    implements ViewModelHolder<UnavailabilityFormViewModel> {
  @override
  UnavailabilityFormViewModel viewModel = GetIt.instance.get();
  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    viewModel.loadForm(widget.event);
    isEditMode = viewModel.isEditMode;
  }

  @override
  void handleNavigationEvent(UnavailabilityFormNavigation event) {
    if (event is Calendar) {
      Navigator.of(context).pop("reload");
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Make label
    String appBarLabel = !isEditMode
        ? (AppLocalizations.of(context)?.addUnavailabilityTitle ?? '')
        : (AppLocalizations.of(context)?.editUnavailabilityTitle ?? '');
    return Scaffold(
      appBar: fireAppAppBar(context, appBarLabel),
      body: SafeArea(
          child: ScrollViewBottomContent(
              padding: EdgeInsets.all(1.rdp()),
              bottomChildren: [
            FillWidth(
                child: StreamBuilder<bool>(
                    stream: viewModel.isFormValidStream,
                    builder: (context, isFormValidSnapshot) {
                      return StreamBuilder(
                        stream: viewModel.submissionState,
                        builder: (context, data) {
                          final isFormValid = isFormValidSnapshot.data ?? false;
                          final submitButtonLabel = !isEditMode
                              ? (AppLocalizations.of(context)
                                      ?.addUnavailabilityButton ??
                                  "Add Schedule")
                              : (AppLocalizations.of(context)
                                      ?.editUnavailabilityButton ??
                                  "Add Edit");
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(40),
                            ),
                            onPressed:
                                isFormValid ? viewModel.submitForm : null,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(submitButtonLabel),
                                if (data is LoadingRequestState)
                                  SizedBox(
                                    height: 8,
                                    width: 8,
                                    child: CircularProgressIndicator(
                                        color: (Theme.of(context)
                                                .primaryTextTheme
                                                .titleLarge
                                                ?.color ??
                                            Colors.white)
                                    ),
                                  )
                              ],
                            ),
                          );
                        },
                      );
                    })
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
                        labelText: AppLocalizations.of(context)
                                ?.enterUnavailabilityTitle ??
                            "",
                        prefixIcon: const Icon(Icons.event_note)),
                    style: Theme.of(context).textTheme.labelLarge,
                    validator: (v) => v!.isEmpty
                        ? AppLocalizations.of(context)?.eventTitleEmptyError
                        : null,
                  ),
                  StreamFormField<DateTime?>(
                      stream: viewModel.selectedStartDate,
                      builder: (context, selectedStartDate) {
                        return DateFormField(
                            currentValue: selectedStartDate,
                            onValueChanged: viewModel.updateStartDate,
                            decoration:
                                textFieldStylePositioned(context).copyWith(
                              prefixIcon: const Icon(Icons.calendar_today),
                              labelText: AppLocalizations.of(context)
                                  ?.enterUnavailabilityStartDate,
                            )
                        );
                      }),
                  StreamFormField<TimeOfDay?>(
                      stream: viewModel.selectedStartTime,
                      builder: (context, value) {
                        return TimeFormField(
                          currentValue: value,
                          onValueChanged: viewModel.updateStartTime,
                          decoration:
                              textFieldStylePositioned(context).copyWith(
                            prefixIcon: const Icon(Icons.hourglass_top),
                            labelText: AppLocalizations.of(context)
                                ?.enterUnavailabilityStartTime,
                          ),
                        );
                      }),
                  StreamFormField<DateTime?>(
                      stream: viewModel.selectedEndDate,
                      builder: (context, value) {
                        return DateFormField(
                            currentValue: value,
                            onValueChanged: viewModel.updateEndDate,
                            decoration:
                                textFieldStylePositioned(context).copyWith(
                              prefixIcon: const Icon(Icons.calendar_today),
                              labelText: AppLocalizations.of(context)
                                  ?.enterUnavailabilityEndDate,
                            )
                        );
                      }),
                  StreamFormField<TimeOfDay?>(
                      stream: viewModel.selectedEndTime,
                      builder: (context, value) {
                        return TimeFormField(
                          currentValue: value,
                          onValueChanged: viewModel.updateEndTime,
                          decoration:
                              textFieldStylePositioned(context).copyWith(
                            prefixIcon: const Icon(Icons.hourglass_bottom),
                            labelText: AppLocalizations.of(context)
                                ?.enterUnavailabilityEndTime,
                          ),
                        );
                      }),
                ].spacedBy(1.rdp()),
              ),
            )
          ])
      ),
    );
  }
}
