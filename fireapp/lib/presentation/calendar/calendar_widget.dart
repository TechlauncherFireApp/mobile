import 'package:fireapp/base/spaced_by.dart';
import 'package:fireapp/base/widget.dart';
import 'package:fireapp/domain/models/unavailability/unavailability_time.dart';
import 'package:fireapp/presentation/calendar/calendar_navigation.dart';
import 'package:fireapp/presentation/fireapp_page.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import '../../domain/models/calendar_event.dart';
import '../../domain/models/shift.dart';
import '../unavailability_form/unavailability_form_widget.dart';
import 'calendar_view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fireapp/base/date_contants.dart';
class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: CalendarView(),
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

  late DateTime _selectedDate;
  late String _selectedMonthLabel;

  @override
  void initState() {
    super.initState();
    // Load events and selected month
    viewModel.loadAndSetDisplayEvents();
    _selectedDate =
        DateTime(viewModel.selectedYear.value, viewModel.selectedMonth.value);
    _selectedMonthLabel = DateFormat(calendarAppBarPresentableDate).format(_selectedDate);
  }

  @override
  void handleNavigationEvent(CalendarNavigation navEvent) {
    // //Navigate to the form, and reload when return
    navEvent.when(
        eventDetail: (event) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => UnavailabilityFormPage(event: event),
        ),
      ).then((result) {
        if (result == 'reload') {
          viewModel.loadAndSetDisplayEvents();
        }
      });
    });
  }

// Group all filtered display events to their day
  Map<DateTime, List<CalendarEvent>> groupEventsByDate(
      List<CalendarEvent> events) {

    Map<DateTime, List<CalendarEvent>> groupedEvents = {};
    for (var event in events) {
      DateTime dateOnly = DateTime(event.displayDate.year,
          event.displayDate.month, event.displayDate.day);
      groupedEvents.putIfAbsent(dateOnly, () => []).add(event);
    }

    return groupedEvents;
  }

  // Construct the list of events for selected month
  // Construct the list of events for selected month
  Widget buildEvents(List<CalendarEvent> events) {
    var groupedEvents = groupEventsByDate(events);
    List<Widget> eventWidgets = [];

    for (var entry in groupedEvents.entries) {
      List<Widget> dayEvents = [
        for (int i = 0; i < entry.value.length; i++)
          _buildEventCard(entry.value[i], i, entry.value.length)
      ];

      eventWidgets.add(Row(
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
                      fontSize: 20, fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  DateFormat('d').format(entry.key),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(children: dayEvents),
          ),
        ],
      ));
    }

    return Column(children: eventWidgets.spacedBy(16));
  }



  Widget _buildEventCard(CalendarEvent calendarEvent, int index, int totalEvents) {
    return calendarEvent.event.when(
      unavailability: (unavailabilityEvent) => _buildUnavailabilityCard(unavailabilityEvent, calendarEvent, index, totalEvents),
      shift: (shiftEvent) => _buildShiftCard(shiftEvent, calendarEvent, index, totalEvents),
    );
  }

  Widget _buildUnavailabilityCard(UnavailabilityTime unavailabilityEvent, CalendarEvent calendarEvent, int index, int totalEvents) {
    final title = unavailabilityEvent.title;
    final displayTime = calendarEvent.displayTime;
    final eventId = unavailabilityEvent.eventId;
    final cardColor = viewModel.getColorForEvent(eventId.toString());

    return Card(
      color: cardColor,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        title: Text(title),
        subtitle: Text(displayTime),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {},
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'Edit',
              onTap: () {
                viewModel.editEventNavigate(unavailabilityEvent);
              },
              child: Text(AppLocalizations.of(context)?.calendarItemEdit ?? "Edit"),
            ),
            PopupMenuItem<String>(
              value: 'Delete',
              child: Text(AppLocalizations.of(context)?.calendarItemDelete ?? "Delete"),
              onTap: () {
                viewModel.deleteUnavailability(eventId);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShiftCard(Shift shiftEvent, CalendarEvent calendarEvent, int index, int totalEvents) {
    final title = shiftEvent.title;
    final displayTime = calendarEvent.displayTime;
    final eventId = shiftEvent.shiftId;
    final cardColor = viewModel.getColorForEvent(eventId.toString());

    return Card(
      color: cardColor,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(displayTime),
            Text(AppLocalizations.of(context)?.shift_status(shiftEvent.status) ?? ''),
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
            _selectedMonthLabel,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24
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
              return const Center(
                  child: CircularProgressIndicator()
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                  child: Text(
                      AppLocalizations.of(context)?.calendarNoItemsLabel ??
                          "No events to display"
                  )
              );
            }
            // Sort events by date
            var sortedEvents = snapshot.data!
              ..sort((a, b) => a.displayDate.compareTo(b.displayDate));

            var groupedEvents = groupEventsByDate(sortedEvents);

            return ListView.builder(
              itemCount: groupedEvents.length,
              itemBuilder: (context, index) {
                var entry = groupedEvents.entries.elementAt(index);
                return Container(
                  margin: EdgeInsets.only(
                      top: index == 0 ? 10 : 20,
                      bottom: index == groupedEvents.length - 1 ? 70 : 10
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
                                  fontSize: 16, fontWeight: FontWeight.bold
                              ),
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
                          children:
                              List.generate(entry.value.length, (eventIndex) {
                            return _buildEventCard(entry.value[eventIndex],
                                eventIndex, entry.value.length);
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // Make temp placeholder event and navigate to form
          var newEvent = UnavailabilityTime(
              eventId: -1,
              userId: -1,
              title: "",
              periodicity: 0,
              startTime: DateTime.now(),
              endTime: DateTime.now()
          );
          viewModel.editEventNavigate(newEvent);
        },
      ),
    );
  }

  // Month picker modal for selecting month and year
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
                                  _selectedDate.year - 1, _selectedDate.month
                              );
                            });
                          },
                        ),
                        Text(
                          '${_selectedDate.year}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_right),
                          onPressed: () {
                            dialogSetState(() {
                              _selectedDate = DateTime(
                                  _selectedDate.year + 1, _selectedDate.month
                              );
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
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          String month = DateFormat('MMM')
                              .format(DateTime(_selectedDate.year, index + 1));
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pop(DateTime(_selectedDate.year, index + 1));
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
          _selectedMonthLabel = DateFormat('MMM yyyy').format(_selectedDate);
          viewModel.updateSelectedYear(_selectedDate.year);
          viewModel.updateSelectedMonth(_selectedDate.month);
          viewModel
              .loadAndSetDisplayEvents(); // Ensure events are reloaded when new date is selected
        });
      }
    });
  }
}
