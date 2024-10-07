import 'package:fireapp/base/spaced_by.dart';
import 'package:fireapp/presentation/volunteer_home/volunteer_home_view_model.dart';
import 'package:fireapp/style/theme.dart';
import 'package:fireapp/widgets/request_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../base/widget.dart';
import '../../domain/models/shift.dart';
import '../../domain/request_state.dart';
import '../fireapp_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../style/typography.dart';
import '../../style/colors.dart';
import '../../base/date_contants.dart';

class VolunteerHomePage extends StatefulWidget {
  const VolunteerHomePage({super.key});

  @override
  State createState() => _VolunteerHomePageState();
}

class _VolunteerHomePageState extends FireAppState<VolunteerHomePage>
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
      return Scaffold(
        body: SafeArea (
          child: RequestStateWidget.stream<List<Shift>>
          (state: viewModel.shiftsStream,
          retry: () => viewModel.fetchShifts(),
          child: (context, shifts) {
            if (shifts.isEmpty) {
              return Center(child: Text(AppLocalizations
                  .of(context)
                  ?.no_shift_avail ?? ""));
            }

            final nextShift = shifts.first;

            return Container(
              height: double.infinity,
              child: SingleChildScrollView(
                  child: Padding(
                      padding: EdgeInsets.all(1.5.rdp()),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations
                                    .of(context)
                                    ?.next_shift ?? "",
                                style: textTheme.titleLarge,
                              ),
                              _buildShiftCard(nextShift, isNextShift: true),
                            ].spacedBy(1.0.rdp()),
                          ),

                          if (shifts.length > 1)
                          // Upcoming Shifts section
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations
                                      .of(context)
                                      ?.upcoming_shift ?? "",
                                  style: textTheme.titleLarge,
                                ),
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
                              ].spacedBy(1.0.rdp()),
                            )
                        ].spacedBy(1.5.rdp()),
                      )
                  )
              ),
            );
          })
        )
      );
  }

  Widget _buildShiftCard(Shift shift, {bool isNextShift = false}) {
    final dateFormat = DateFormat(homeDate);
    final timeFormat = DateFormat(homeTime);

    return Card(
      color: isNextShift ? homeRedColor : homeBlueColor,
      child: Padding(
        padding: EdgeInsets.all(1.0.rdp()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(shift.title,
                    style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                Text(AppLocalizations.of(context)!.shift_id_display_home(shift.shiftId))
              ].spacedBy(1.0.rdp()),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dateFormat.format(shift.start),
                    style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                Text(AppLocalizations.of(context)!.shift_time_range(
                    timeFormat.format(shift.start),
                    timeFormat.format(shift.end)
                ))
              ].spacedBy(0.25.rdp()),
            )
          ].spacedBy(1.0.rdp())
        ),
      ),
    );
  }
}
