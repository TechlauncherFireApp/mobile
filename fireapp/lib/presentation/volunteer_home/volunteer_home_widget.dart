import 'package:fireapp/domain/models/shift.dart';
import 'package:fireapp/presentation/volunteer_home/volunteer_home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../base/widget.dart';
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
    viewModel.fetchAndSetShifts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<List<Shift>>(
          stream: viewModel.displayShiftsStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text("No Shift to display"),
              );
            }

            // If data is available, group shifts by date
            var groupedShifts = groupShiftsByDate(snapshot.data!);

            return ListView.builder(
              itemCount: groupedShifts.length,
              itemBuilder: (context, index) {
                var entry = groupedShifts.entries.elementAt(index);
                return Container(
                  margin: EdgeInsets.only(
                    top: index == 0 ? 10 : 20,
                    bottom: index == groupedShifts.length - 1 ? 70 : 10,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 60,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat('MMM').format(entry.key).toUpperCase(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              DateFormat('d').format(entry.key),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: List.generate(entry.value.length, (shiftIndex) {
                            return _buildShiftCard(
                                entry.value[shiftIndex], shiftIndex, entry.value.length);
                          }),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

// Helper method to group shifts by date
  Map<DateTime, List<Shift>> groupShiftsByDate(List<Shift> shifts) {
    Map<DateTime, List<Shift>> groupedShifts = {};
    for (var shift in shifts) {
      DateTime dateOnly = DateTime(shift.startTime.year, shift.startTime.month, shift.startTime.day);
      groupedShifts.putIfAbsent(dateOnly, () => []).add(shift);
    }
    return groupedShifts;
  }

// Helper method to build a shift card
  Widget _buildShiftCard(Shift shift, int index, int totalShifts) {
    final shiftStartTime = DateFormat('h:mm a').format(shift.startTime);
    final shiftEndTime = DateFormat('h:mm a').format(shift.endTime);
    final shiftDuration = "$shiftStartTime - $shiftEndTime";

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        title: Text('Shift ID: ${shift.shiftId}'),
        subtitle: Text(shiftDuration),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            // Handle actions like edit or delete
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'Edit',
              child: Text("Edit"),
            ),
            const PopupMenuItem<String>(
              value: 'Delete',
              child: Text("Delete"),
            ),
          ],
        ),
      ),
    );
  }

}
