import 'package:fireapp/presentation/shift_request/shift_request_view_model.dart';
import 'package:fireapp/style/theme.dart';
import 'package:flutter/material.dart';
import '../../domain/models/shift_request.dart';
import '../../domain/request_state.dart';
import '../../global/di.dart';
import '../../widgets/fireapp_app_bar.dart';
import '../../widgets/request_state_widget.dart';
import 'ShiftRequestWidget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension SpacedByExtension on List<Widget> {
  List<Widget> spacedBy(double space) {
    if (this.isEmpty) return [];
    return this.expand((widget) => [widget, SizedBox(height: space)]).toList()..removeLast();
  }
}

class ShiftRequestView extends StatefulWidget {
  final String requestId;

  const ShiftRequestView({Key? key, required this.requestId}) : super(key: key);

  @override
  _ShiftRequestViewState createState() => _ShiftRequestViewState();
}

class _ShiftRequestViewState extends State<ShiftRequestView> {
  late final ShiftRequestViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<ShiftRequestViewModel>();
    _viewModel.loadShiftRequests(requestId: widget.requestId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: fireAppAppBar(context, AppLocalizations.of(context)!.shift_request_details), // Using fireAppAppBar here
      body: RequestStateWidget.stream<List<ShiftRequest>>(
        state: _viewModel.shiftRequests,
        retry: () => _viewModel.loadShiftRequests(requestId: widget.requestId),
        child: (_, shiftRequests) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.rdp()),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 1.rdp()),
                  ...shiftRequests.map((shiftRequest) {
                    return Column(
                      children: [
                        _buildContainer(
                          ShiftRequestWidget(title: AppLocalizations.of(context)!.shift_id, content: shiftRequest.shiftID),
                        ),
                        _buildContainer(
                          ShiftRequestWidget(title: AppLocalizations.of(context)!.asset_class, content: shiftRequest.assetClass),
                        ),
                        _buildContainer(
                          ShiftRequestWidget(title: AppLocalizations.of(context)!.start_time, content: shiftRequest.startTime.toIso8601String()),
                        ),
                        _buildContainer(
                          ShiftRequestWidget(title: AppLocalizations.of(context)!.end_time, content: shiftRequest.endTime.toIso8601String()),
                        ),
                        ...shiftRequest.shiftVolunteers.map((volunteer) {
                          return Column(
                            children: [
                              _buildContainer(
                                ShiftRequestWidget(title: AppLocalizations.of(context)!.volunteer_name, content: '${volunteer.volunteerGivenName} ${volunteer.volunteerSurname}'),
                              ),
                              _buildContainer(
                                ShiftRequestWidget(title: AppLocalizations.of(context)!.mobile_number, content: volunteer.mobileNumber),
                              ),
                              _buildContainer(
                                ShiftRequestWidget(title: AppLocalizations.of(context)!.position_id, content: volunteer.positionId.toString()),
                              ),
                              _buildContainer(
                                ShiftRequestWidget(title: AppLocalizations.of(context)!.role, content: volunteer.role),
                              ),
                              _buildContainer(
                                ShiftRequestWidget(title: AppLocalizations.of(context)!.status, content: volunteer.status),
                              ),
                            ].spacedBy(0.5.rdp()),
                          );
                        }).toList(),
                        SizedBox(height: 1.rdp()),
                      ].spacedBy(0.5.rdp()),
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContainer(Widget child) {
    return Container(
      padding: EdgeInsets.all(0.5.rdp()),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(0.5.rdp()),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
