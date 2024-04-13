import 'package:fireapp/base/widget.dart';
import 'package:fireapp/presentation/calendar/calendar_navigation.dart';
import 'package:fireapp/presentation/fireapp_page.dart';
import 'package:fireapp/style/theme.dart';
import 'package:fireapp/widgets/fill_width.dart';
import 'package:fireapp/widgets/scroll_view_bottom_content.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
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

  @override
  void handleNavigationEvent(CalendarNavigation event) {

  }

  @override
  Widget build(BuildContext context) {
    return ScrollViewBottomContent(
      padding: EdgeInsets.all(1.rdp()),
      bottomChildren: const [
        FillWidth(child: Placeholder()),
      ],
      children: const [Text("Calendar placeholder")],
    );
  }
}
