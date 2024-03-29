import 'package:fireapp/base/date_contants.dart';
import 'package:fireapp/base/spaced_by.dart';
import 'package:fireapp/base/widget.dart';
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
import 'package:fireapp/presentation/constraint_form/constraint_form_view_model.dart';
import 'package:fireapp/presentation/constraint_form/base_input_field.dart';
import 'package:get_it/get_it.dart';

import '../../domain/models/reference/asset_type.dart';
import '../../domain/request_state.dart';
import '../../widgets/request_state_widget.dart';

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
    with Navigable<ConstraintFormNavigation, SchedulerConstraintForm>
    implements ViewModelHolder<SchedulerConstraintFormViewModel> {

  @override
  SchedulerConstraintFormViewModel viewModel = GetIt.instance.get();

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
        SizedBox(height: 1.rdp(),),
        FillWidth(
          child: StreamBuilder(
            stream: viewModel.submissionState,
            builder: (context, data) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                ),
                onPressed: viewModel.submitForm,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context)?.addSchedule ?? "Add Schedule"),
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
                  labelText: AppLocalizations.of(context)?.scheduleName ?? "",
                  prefixIcon: const Icon(Icons.label_outline)
                ),
                style: Theme.of(context).textTheme.labelLarge,
                validator: (v) => v!.isEmpty ? 'Title is empty!' : null,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: RequestStateWidget.stream<List<AssetType>>(
                      state: viewModel.assetsStream,
                      shouldExpand: false,
                      child: (context, assetTypes) {
                        return DropdownButtonFormField<AssetType>(
                          decoration: textFieldStylePositioned(
                            context,
                          ).copyWith(
                            labelText: AppLocalizations.of(context)?.selectAsset,
                            prefixIcon: const Icon(Icons.car_rental_outlined),
                          ),
                          items: assetTypes.map<DropdownMenuItem<AssetType>>(
                                (AssetType asset) {
                              return DropdownMenuItem<AssetType>(
                                value: asset,
                                child: Text(
                                  asset.name, // Adjust this based on your AssetType structure
                                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: Theme.of(context).colorScheme.shadow,
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                          onChanged: (AssetType? newValue) {
                            if (newValue != null) {
                              viewModel.selectedAsset = newValue;
                            }
                          },
                        );
                      },
                      retry: () => viewModel.fetchAssetTypes()
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
