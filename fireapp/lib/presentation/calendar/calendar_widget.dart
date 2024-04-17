import 'package:fireapp/base/widget.dart';
import 'package:fireapp/presentation/calendar/calendar_navigation.dart';
import 'package:fireapp/presentation/fireapp_page.dart';
import 'package:fireapp/style/theme.dart';
import 'package:fireapp/widgets/fill_width.dart';
import 'package:fireapp/widgets/scroll_view_bottom_content.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import '../../pages/Calendar/calendarForm.dart';
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

  String _selectedMonth = DateFormat('MMMM').format(DateTime.now());

  // 可选的月份列表
  final List<String> _months = List.generate(12, (i) => DateFormat('MMMM').format(DateTime(0, i + 1)));
  @override
  CalendarViewModel viewModel = GetIt.instance.get();

  @override
  void handleNavigationEvent(CalendarNavigation event) {

  }
  Widget _buildEventCard(String title, String timeRange) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
        title: Text(title),
        subtitle: Text(timeRange),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {

          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
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
        title: DropdownButton<String>(
          underline: Container(),
          value: _selectedMonth,
          items: _months.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              if (newValue != null) {
                _selectedMonth = newValue;
              }
            });
          },
          isExpanded: false,
          iconSize: 24.0,
          elevation: 16,
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(right: 15.0),
                    child: Text(
                      'April 27',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: _buildEventCard('Meeting', '2pm - 4pm'),
                ),
              ],
            ),
            // Add more event rows here
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          // Add your onPressed logic here
        },
      ),
    );
  }
}