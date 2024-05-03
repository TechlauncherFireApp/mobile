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

class _CalendarState extends FireAppState<CalendarView> with Navigable<CalendarNavigation, CalendarView> implements ViewModelHolder<CalendarViewModel> {
  @override
  CalendarViewModel viewModel = GetIt.instance.get();
  final List<Color> colorPalette = [
    const Color(0xFFB9DEEC), // Light Blue
    const Color(0xFFCBCBEA), // Lavender
    const Color(0xFFFDD2D7), // Pink
    const Color(0xFFFCFCDC), // Light Yellow
    const Color(0xFFEFEFEF), // Light Gray
    const Color(0xFFF6CEBC),  // Light Orange
    const Color(0xFFCFDEE3),
    const Color(0xFFCBE4F1),
  ];
  int _nextColorIndex = 0;

  final Map<String, Color> eventColorMap = {};

  Color? getColorForEvent(String eventId) {
    if (!eventColorMap.containsKey(eventId)) {
      eventColorMap[eventId] = colorPalette[_nextColorIndex];
      _nextColorIndex = (_nextColorIndex + 1) % colorPalette.length;
    }
    return eventColorMap[eventId];
  }

  String _selectedMonth = DateFormat('MMM yyyy').format(DateTime.now());
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    viewModel.loadAndSetDisplayEvents();
  }

  @override
  void handleNavigationEvent(CalendarNavigation event) {
    event.when(eventDetail: (eventId) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const UnavailabilityForm()));
    });
  }

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

  Widget buildEvents(List<CalendarEvent> events) {
    var groupedEvents = groupEventsByDate(events);
    List<Widget> eventWidgets = [];
    bool isFirstGroup = true;

    for (var entry in groupedEvents.entries) {
      if (!isFirstGroup) {
        eventWidgets.add(const SizedBox(height: 20));
      }
      isFirstGroup = false;
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
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  DateFormat('d').format(entry.key),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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

    return Column(children: eventWidgets);
  }

  Widget _buildEventCard(CalendarEvent event, int index, int totalEvents) {
    final title = event.event.title;
    final displayTime = event.displayTime;
    final eventId = event.event.eventId;
    final cardColor = getColorForEvent(eventId.toString());

    // Check if this card is the last one in the list
    final bool isLastCard = index == totalEvents - 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 16), // Add default bottom margin
      child: Card(
        color: cardColor,
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: ListTile(
          title: Text(title),
          subtitle: Text(displayTime),
          trailing: PopupMenuButton<String>(
            onSelected: (value) {},
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(value: 'Edit', child: Text('Edit')),
              PopupMenuItem<String>(
                value: 'Delete',
                child: const Text('Delete'),
                onTap: () {
                  viewModel.deleteUnavailability(eventId);
                },
              ),
            ],
          ),
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
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
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
            // Sort events by date
            var sortedEvents = snapshot.data!
              ..sort((a, b) => a.displayDate.compareTo(b.displayDate));

            var groupedEvents = groupEventsByDate(sortedEvents);

            return ListView.builder(
              itemCount: groupedEvents.length,
              itemBuilder: (context, index) {
                var entry = groupedEvents.entries.elementAt(index);
                return Container(
                  margin: EdgeInsets.only(top: index == 0 ? 10 : 20, bottom: index == groupedEvents.length - 1 ? 70 : 10), // 在最后一张卡片下方添加额外的空间
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
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
                          children: List.generate(entry.value.length, (eventIndex) {
                            return _buildEventCard(entry.value[eventIndex], eventIndex, entry.value.length);
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
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const UnavailabilityFormPage()));
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
