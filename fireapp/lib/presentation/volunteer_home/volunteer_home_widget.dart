import 'package:fireapp/presentation/volunteer_home/volunteer_home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

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
  Widget build(BuildContext context) {
    return const SizedBox.expand( // Ensures the child takes up all available space
      child: Placeholder(
        child: Center(child: Text("Some text")),
      ),
    );
  }
}
