import 'package:fireapp/base/spaced_by.dart';
import 'package:fireapp/base/widget.dart';
import 'package:fireapp/presentation/unavailability_form/unavaliability_form_view_model.dart';
import 'package:fireapp/presentation/constraint_form/constraint_form_navigation.dart';
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
import 'package:get_it/get_it.dart';
import '../../domain/request_state.dart';

class UnavailabilityFormPage extends StatelessWidget {
  const UnavailabilityFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: fireAppAppBar(context, AppLocalizations.of(context)?.addUnavailabilityTitle ?? ''),
      body: const SafeArea(
        child: UnavailabilityForm(),
      ),
    );
  }
}

class UnavailabilityForm extends StatefulWidget {
  const UnavailabilityForm({super.key});

  @override
  State createState() =>
      _UnavailabilityFormState();

}

class _UnavailabilityFormState
    extends FireAppState<UnavailabilityForm>
    with Navigable<ConstraintFormNavigation, UnavailabilityForm>
    implements ViewModelHolder<UnavailabilityFormViewModel> {

  @override
  UnavailabilityFormViewModel viewModel = GetIt.instance.get();

  @override
  void handleNavigationEvent(ConstraintFormNavigation event) {
    event.when(
        shiftRequest: (requestId) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ShiftRequestView(requestId: requestId)
          ));
        }
    );
  }

  @override
  Widget build(BuildContext context) {

    return ScrollViewBottomContent(
        padding: EdgeInsets.all(1.rdp()),
        bottomChildren: [
          FillWidth(
            child: StreamBuilder(
              stream: viewModel.submissionState,
              builder: (context, data) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                  ),
                  // onPressed: viewModel.submitForm,
                  onPressed: () {  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppLocalizations.of(context)?.addUnavailabilityButton ?? "Add Schedule"),
                      if (data is LoadingRequestState) SizedBox(
                        height: 8,
                        width: 8,
                        child: CircularProgressIndicator(
                            color: (Theme.of(context).primaryTextTheme.headline6?.color ?? Colors.white)
                        ),
                      )
                    ],
                  ),
                );
              },
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
                      labelText: AppLocalizations.of(context)?.enterUnavailabilityTitle ?? "",
                      prefixIcon: const Icon(Icons.event_note)
                  ),
                  style: Theme.of(context).textTheme.labelLarge,
                  validator: (v) => v!.isEmpty ?
                    AppLocalizations.of(context)?.eventTitleEmptyError: null,
                ),
                StreamFormField<DateTime?>(
                    stream: viewModel.selectedStartDate,
                    builder: (context, value) {
                      return DateFormField(
                          currentValue: value,
                          onValueChanged: viewModel.updateStartDate,
                          decoration: textFieldStylePositioned(context).copyWith(
                            prefixIcon: const Icon(Icons.calendar_today),
                            labelText: AppLocalizations.of(context)?.enterUnavailabilityStartDate,
                          )
                      );
                    }
                ),
                StreamFormField<TimeOfDay?>(
                    stream: viewModel.selectedStartTime,
                    builder: (context, value) {
                      return TimeFormField(
                        currentValue: value,
                        onValueChanged: viewModel.updateStartTime,
                        decoration: textFieldStylePositioned(context).copyWith(
                          prefixIcon: const Icon(Icons.hourglass_top),
                          labelText: AppLocalizations.of(context)?.enterUnavailabilityStartTime,
                        ),
                      );
                    }
                ),
                StreamFormField<DateTime?>(
                    stream: viewModel.selectedEndDate,
                    builder: (context, value) {
                      return DateFormField(
                          currentValue: value,
                          onValueChanged: viewModel.updateEndDate,
                          decoration: textFieldStylePositioned(context).copyWith(
                            prefixIcon: const Icon(Icons.calendar_today),
                            labelText: AppLocalizations.of(context)?.enterUnavailabilityEndDate,
                          )
                      );
                    }
                ),
                StreamFormField<TimeOfDay?>(
                    stream: viewModel.selectedEndTime,
                    builder: (context, value) {
                      return TimeFormField(
                        currentValue: value,
                        onValueChanged: viewModel.updateEndTime,
                        decoration: textFieldStylePositioned(context).copyWith(
                          prefixIcon: const Icon(Icons.hourglass_bottom),
                          labelText: AppLocalizations.of(context)?.enterUnavailabilityEndTime,
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
