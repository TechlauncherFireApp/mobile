import 'package:fireapp/base/widget.dart';
import 'package:fireapp/presentation/calendar/calendar_navigation.dart';
import 'package:fireapp/presentation/fireapp_page.dart';
import 'package:fireapp/style/theme.dart';
import 'package:fireapp/widgets/fill_width.dart';
import 'package:fireapp/widgets/scroll_view_bottom_content.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import '../../domain/models/calendar_event.dart';
import '../../pages/Calendar/calendarForm.dart';
import '../unavailability_form/unavailability_form_widget.dart';
import 'calendar_view_model.dart';


class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SafeArea(
        child: CalendarView(),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        //TODO navigation refactor - carried from old code
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CalendarFormRoute()),
          );
        },
      ),
    );
  }
}


class CalendarView extends StatefulWidget {
  const CalendarView({super.key});


  @override
  State createState() => _CalendarState();
}


class _CalendarState extends FireAppState<CalendarView>
    with Navigable<CalendarNavigation, CalendarView>
    implements ViewModelHolder<CalendarViewModel> {


  @override
  CalendarViewModel viewModel = GetIt.instance.get();
  String _selectedMonth = DateFormat('MMM yyyy').format(DateTime.now());
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    viewModel.loadAndSetDisplayEvents();
  }

  @override
  void handleNavigationEvent(CalendarNavigation event) {
    event.when(
        eventDetail: (eventId) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => UnavailabilityForm()
          ));
        }
    );
  }

  Widget _buildEventCard(String title, String timeRange) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
        title: Text(title),
        subtitle: Text(timeRange),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {},
          itemBuilder: (BuildContext context) =>
          <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'Edit',
              child: Text('Edit'),
            ),
            const PopupMenuItem<String>(
              value: 'Delete',
              child: Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextButton(
          onPressed: () => _showMonthPicker(context),
          child: Text(
            _selectedMonth,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: StreamBuilder<List<CalendarEvent>>(
          stream: viewModel.displayEventsStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No events to display"));
            }
            return ListView(
              children: snapshot.data!.map((event) =>
                  _buildEventCard(event.event.title,
                      "${DateFormat('h:mm a').format(
                          event.event.startTime)} - ${DateFormat('h:mm a')
                          .format(event.event.endTime)}")).toList(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => UnavailabilityFormPage())
          );
        },
      ),
    );
  }


  void _showMonthPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: double.maxFinite,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter dialogSetState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_left),
                          onPressed: () {
                            dialogSetState(() {
                              _selectedDate = DateTime(
                                  _selectedDate.year - 1, _selectedDate.month);
                            });
                          },
                        ),
                        Text(
                          '${_selectedDate.year}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_right),
                          onPressed: () {
                            dialogSetState(() {
                              _selectedDate = DateTime(
                                  _selectedDate.year + 1, _selectedDate.month);
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 220,
                      child: GridView.builder(
                        shrinkWrap: true,
                        itemCount: 12,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          String month = DateFormat('MMM').format(
                              DateTime(_selectedDate.year, index + 1));
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop(DateTime(
                                  _selectedDate.year, index + 1));
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(month.toUpperCase()),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    ).then((selectedDate) {
      if (selectedDate != null) {
        setState(() {
          _selectedDate = selectedDate as DateTime;
          _selectedMonth = DateFormat('MMM yyyy').format(_selectedDate);
          viewModel.updateSelectedYear(_selectedDate.year);
          viewModel.updateSelectedMonth(_selectedDate.month);
          viewModel
              .loadAndSetDisplayEvents(); // Ensure events are reloaded when new date is selected
        });
      }
    });
  }
}