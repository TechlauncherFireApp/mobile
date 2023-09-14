import 'package:fireapp/presentation/shift_request/shift_request_view_model.dart';
import 'package:flutter/material.dart';
import '../../domain/models/shift_request.dart';
import '../../domain/request_state.dart';
import '../../global/di.dart';
import 'ShiftRequestWidget.dart'; // Ensure the correct path is used

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
    _viewModel = getIt<ShiftRequestViewModel>(); // Assuming you're using getIt for DI
    _viewModel.loadShiftRequests(widget.requestId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shift Request Details'), // Localize this if needed
      ),
      body: StreamBuilder<RequestState<List<ShiftRequest>>>(
        stream: _viewModel.shiftRequests,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final state = snapshot.data!;
            if (state is LoadingRequestState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is SuccessRequestState<List<ShiftRequest>>) {
              final shiftRequests = state.result;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: shiftRequests.map((shiftRequest) {
                      return Column(
                        children: [
                          ShiftRequestWidget(title: 'Shift ID', content: shiftRequest.shiftID),
                          ShiftRequestWidget(title: 'Asset Class', content: shiftRequest.assetClass),
                          ShiftRequestWidget(title: 'Start Time', content: shiftRequest.startTime.toString()),
                          ShiftRequestWidget(title: 'End Time', content: shiftRequest.endTime.toString()),
                          ...shiftRequest.shiftVolunteers.map((volunteer) {
                            return Column(
                              children: [
                                ShiftRequestWidget(title: 'Volunteer Name', content: '${volunteer.volunteerGivenName} ${volunteer.volunteerSurname}'),
                                ShiftRequestWidget(title: 'Mobile Number', content: volunteer.mobileNumber),
                                ShiftRequestWidget(title: 'Position ID', content: volunteer.positionId.toString()),
                                ShiftRequestWidget(title: 'Role', content: volunteer.role),
                                ShiftRequestWidget(title: 'Status', content: volunteer.status),
                              ],
                            );
                          }).toList(),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              );
            } else if (state is ExceptionRequestState) {
              return Center(child: Text('Error:'));
            }
          }
          return SizedBox.shrink(); // Default empty state
        },
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
