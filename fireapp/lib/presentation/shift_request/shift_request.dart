import 'package:fireapp/presentation/shift_request/shift_request_view_model.dart';
import 'package:flutter/material.dart';
import '../../domain/models/shift_request.dart';
import '../../domain/request_state.dart';
import '../../global/di.dart';
import '../../widgets/request_state_widget.dart';
import 'ShiftRequestWidget.dart';

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
    _viewModel.loadShiftRequests(widget.requestId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shift Request Details'),
      ),
      body: RequestStateWidget.stream<List<ShiftRequest>>(
        state: _viewModel.shiftRequests,
        retry: () => _viewModel.loadShiftRequests(widget.requestId),
        child: (_, shiftRequests) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: shiftRequests.map((shiftRequest) {
                  return Column(
                    children: [
                      _buildContainer(
                        ShiftRequestWidget(title: 'Shift ID', content: shiftRequest.shiftID),
                      ),
                      _buildContainer(
                        ShiftRequestWidget(title: 'Asset Class', content: shiftRequest.assetClass),
                      ),
                      _buildContainer(
                        ShiftRequestWidget(title: 'Start Time', content: shiftRequest.startTime.toIso8601String()),
                      ),
                      _buildContainer(
                        ShiftRequestWidget(title: 'End Time', content: shiftRequest.endTime.toIso8601String()),
                      ),
                      ...shiftRequest.shiftVolunteers.map((volunteer) {
                        return Column(
                          children: [
                            _buildContainer(
                              ShiftRequestWidget(title: 'Volunteer Name', content: '${volunteer.volunteerGivenName} ${volunteer.volunteerSurname}'),
                            ),
                            _buildContainer(
                              ShiftRequestWidget(title: 'Mobile Number', content: volunteer.mobileNumber),
                            ),
                            _buildContainer(
                              ShiftRequestWidget(title: 'Position ID', content: volunteer.positionId.toString()),
                            ),
                            _buildContainer(
                              ShiftRequestWidget(title: 'Role', content: volunteer.role),
                            ),
                            _buildContainer(
                              ShiftRequestWidget(title: 'Status', content: volunteer.status),
                            ),
                          ],
                        );
                      }).toList(),
                      SizedBox(height: 20),
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContainer(Widget child) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8.0),
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
