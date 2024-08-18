import 'package:fireapp/presentation/volunteer_home/volunteer_home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../base/widget.dart';
import '../../domain/models/shift.dart';
import '../../domain/request_state.dart';
import '../fireapp_page.dart';

class VolunteerHome extends StatelessWidget {
  const VolunteerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: HomeView(),
      ),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State createState() => _HomeState();
}

class _HomeState extends FireAppState<HomeView>
    // with Navigable<CalendarNavigation, HomeView>
    implements
        ViewModelHolder<VolunteerHomeViewModel> {
  @override
  VolunteerHomeViewModel viewModel = GetIt.instance.get();

  @override
  void initState() {
    super.initState();
    print('Initializing HomeView');
    viewModel.fetchShifts();
  }

  @override
  Widget build(BuildContext context) {
      return StreamBuilder<RequestState<List<Shift>>>(stream: viewModel.shiftsStream,
          builder: (context, snapshot) {
            print('StreamBuilder received update: ${snapshot.data}');
            if (!snapshot.hasData) {
              print('No data in snapshot');
              return const Center(child: CircularProgressIndicator());
            }

            final state = snapshot.data!;

            if (state is InitialRequestState) {
              print('Initial state');
              return const Center(child: CircularProgressIndicator());
            } else if (state is LoadingRequestState) {
              print('Loading state');
              return const Center(child: CircularProgressIndicator());
            } else if (state is ExceptionRequestState) {
              var exceptionState = state as ExceptionRequestState;
              print('Exception state: ${exceptionState.exception}');
              return Center(child: Text('Error: ${exceptionState.exception}'));
            } else if (state is SuccessRequestState<List<Shift>>) {
              print('Success state with ${state.result.length} shifts');
              final shifts = state.result;
              if (shifts.isEmpty) {
                return const Center(child: Text("No shifts available."));
              }

              final nextShift = shifts.first;

              return SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your Next Shift:',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: 16),
                          _buildShiftCard(nextShift, isNextShift: true),
                          const SizedBox(height: 24,),
                          const Text(
                            'Upcoming Shifts:',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: 16,),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: shifts.length - 1,
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: _buildShiftCard(shifts[index + 1])
                              );
                            },
                          )
                        ],
                      )
                  )
              );
            } else {
              return const Center(child: Text('Unknown state'));
            }
          });

  }

  Widget _buildShiftCard(Shift shift, {bool isNextShift = false}) {
    final dateFormat = DateFormat('EEEE d MMMM');
    final timeFormat = DateFormat('h:mm a');

    return Card(
      color: isNextShift ? Colors.red[200] : Colors.blue[200],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(dateFormat.format(shift.startTime),
                      style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Shift ID: ${shift.shiftId}')
              ],
            ),
            const SizedBox(height: 8),
            Text('Location: TBD'),
            const SizedBox(height: 8,),
            Text('${timeFormat.format(shift.startTime)} - ${timeFormat.format(shift.endTime)}')
          ]
        ),
      ),
    );
  }
}
