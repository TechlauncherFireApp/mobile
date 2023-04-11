import 'dart:convert';

import 'package:fireapp/base/spaced_by.dart';
import 'package:fireapp/base/widget.dart';
import 'package:fireapp/domain/models/volunteer_information.dart';
import 'package:fireapp/layout/wrapper.dart';
import 'package:fireapp/presentation/fireapp_page.dart';
import 'package:fireapp/presentation/volunteer_information/volunteer_information_viewmodel.dart';
import 'package:fireapp/presentation/volunteer_information/VolunteerInformationWidget.dart';
import 'package:fireapp/widgets/request_state_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fireapp/presentation/volunteer_information/VolunteerInformationWidget.dart';

class VolunteerInformationPage extends StatefulWidget {
  final String volunteerId;

  const VolunteerInformationPage({
    super.key,
    required this.volunteerId,
  });

  @override
  State createState() => _VolunteerInformationState();
}

class _VolunteerInformationState extends FireAppState<VolunteerInformationPage>{
  String getAvailabilityMessage(BuildContext context, List<List<int>> availability) {
    if (availability.isEmpty) {
      return AppLocalizations.of(context)?.unavailable ?? 'Unavailable';
    } else {
      return formatHours(availability);
    }
  }
  String formatHours(List<List<int>> hours) {
    return hours.map((hourRange) => '${formatHour(hourRange[0])} to ${formatHour(hourRange[1])}').join(', ');
  }

  String formatHour(int hour) {
    if (hour == 0) {
      return '12am';
    } else if (hour < 12) {
      return '$hour' + 'am';
    } else if (hour == 12) {
      return '12pm';
    } else {
      return '${hour - 12}' + 'pm';
    }
  }

  @override
  VolunteerInformationViewModel viewModel = GetIt.instance.get();

  @override
  void initState() {
    super.initState();
    viewModel.getVolunteerInformation(widget.volunteerId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.volunteerInformationTitle ??
            'Volunteer Information'),
      ),
        body: RequestStateWidget.stream<VolunteerInformation>(
            state: viewModel.volunteerInformation,
            retry: () => viewModel.getVolunteerInformation(widget.volunteerId),
            child: (_, volunteerInformation) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: VolunteerInformationWidget(
                          title: AppLocalizations.of(context)?.volunteer_id ?? 'ID',
                          content: volunteerInformation.ID,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VolunteerInformationWidget(
                              title: AppLocalizations.of(context)?.volunteer_first_name ?? 'First Name',
                              content: volunteerInformation.firstName,
                            ),
                            VolunteerInformationWidget(
                              title: AppLocalizations.of(context)?.volunteer_last_name ?? 'Last Name',
                              content: volunteerInformation.lastName,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: VolunteerInformationWidget(
                          title: AppLocalizations.of(context)?.volunteer_email ?? 'Email',
                          content: volunteerInformation.email,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: VolunteerInformationWidget(
                          title: AppLocalizations.of(context)?.volunteer_phone ?? 'Phone',
                          content: volunteerInformation.mobileNo,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: VolunteerInformationWidget(
                          title: AppLocalizations.of(context)?.volunteer_prefHours ??
                              'Preferred Hours',
                          content: volunteerInformation.prefHours.toString(),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: VolunteerInformationWidget(
                          title: AppLocalizations.of(context)?.volunteer_expYears ??
                              'Experience Years',
                          content: volunteerInformation.expYears.toString(),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: VolunteerInformationWidget(
                          title: AppLocalizations.of(context)?.volunteer_qualifications ??
                              'Qualifications',
                          content: volunteerInformation.qualifications.map((qualification) => qualification.name)
                              .join('\n'),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: VolunteerInformationWidget(
                          title: AppLocalizations.of(context)?.volunteer_possibleRoles ??
                              'Possible Roles',
                          content: volunteerInformation.possibleRoles.map((role) => role)
                              .join('\n'),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)?.volunteer_availability ?? 'Availability',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            VolunteerInformationWidget(
                              title: AppLocalizations.of(context)?.volunteer_availability_monday ?? 'Monday',
                              content: getAvailabilityMessage(context, volunteerInformation.availabilities.monday),
                            ),
                            VolunteerInformationWidget(
                              title: AppLocalizations.of(context)?.volunteer_availability_tuesday ?? 'Tuesday',
                              content: getAvailabilityMessage(context, volunteerInformation.availabilities.tuesday),
                            ),
                            VolunteerInformationWidget(
                              title: AppLocalizations.of(context)?.volunteer_availability_wednesday ?? 'Wednesday',
                              content: getAvailabilityMessage(context, volunteerInformation.availabilities.wednesday),
                            ),
                            VolunteerInformationWidget(
                              title: AppLocalizations.of(context)?.volunteer_availability_thursday ?? 'Thursday',
                              content: getAvailabilityMessage(context, volunteerInformation.availabilities.thursday),
                            ),
                            VolunteerInformationWidget(
                              title: AppLocalizations.of(context)?.volunteer_availability_friday ?? 'Friday',
                              content: getAvailabilityMessage(context, volunteerInformation.availabilities.friday),
                            ),
                            VolunteerInformationWidget(
                              title: AppLocalizations.of(context)?.volunteer_availability_saturday ?? 'Saturday',
                              content: getAvailabilityMessage(context, volunteerInformation.availabilities.saturday),
                            ),
                            VolunteerInformationWidget(
                              title: AppLocalizations.of(context)?.volunteer_availability_sunday ?? 'Sunday',
                              content: getAvailabilityMessage(context, volunteerInformation.availabilities.sunday),
                            ),
                          ],
                        ),
                      ),

                    ].spacedBy(16),
                  ),
                ),
              );
            },
        ),
    );
  }
}

