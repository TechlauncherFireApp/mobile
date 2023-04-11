import 'dart:convert';

import 'package:fireapp/base/widget.dart';
import 'package:fireapp/domain/models/volunteer_information.dart';
import 'package:fireapp/layout/wrapper.dart';
import 'package:fireapp/presentation/fireapp_page.dart';
import 'package:fireapp/presentation/volunteer_information/volunteer_information_viewmodel.dart';
import 'package:fireapp/widgets/request_state_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fireapp/presentation/volunteer_information/volunteer_information_widget.dart';

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
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    volunteer_information_widget(
                      title: AppLocalizations.of(context)?.volunteer_id ??
                          'ID',
                      content: volunteerInformation.ID,
                    ),
                    volunteer_information_widget(
                      title: AppLocalizations.of(context)?.volunteer_first_name ??
                          'First Name',
                      content: volunteerInformation.firstName,
                    ),
                    volunteer_information_widget(
                      title: AppLocalizations.of(context)?.volunteer_last_name ??
                          'Last Name',
                      content: volunteerInformation.lastName,
                    ),
                    volunteer_information_widget(
                      title: AppLocalizations.of(context)?.volunteer_email ??
                          'Email',
                      content: volunteerInformation.email,
                    ),
                    volunteer_information_widget(
                      title: AppLocalizations.of(context)?.volunteer_phone ??
                          'Phone',
                      content: volunteerInformation.mobileNo,
                    ),
                    volunteer_information_widget(
                      title: AppLocalizations.of(context)?.volunteer_prefHours ??
                          'Preferred Hours',
                      content: volunteerInformation.prefHours.toString(),
                    ),
                    volunteer_information_widget(
                      title: AppLocalizations.of(context)?.volunteer_expYears ??
                          'Experience Years',
                      content: volunteerInformation.expYears.toString(),
                    ),
                    volunteer_information_widget(
                      title: AppLocalizations.of(context)?.volunteer_qualifications ??
                          'Qualifications',
                      content: volunteerInformation.qualifications.map((qualification) => qualification.name)
                                    .join('\n'),
                    ),
                    volunteer_information_widget(
                      title: AppLocalizations.of(context)?.volunteer_possibleRoles ??
                          'Possible Roles',
                      content: volunteerInformation.possibleRoles.map((role) => role)
                                    .join('\n'),
                    ),
                    volunteer_information_widget(
                      title: AppLocalizations.of(context)?.volunteer_availability_monday ??
                          'Availability Monday',
                      content: volunteerInformation.availabilities.monday.isEmpty
                          ? AppLocalizations.of(context)?.unavailable ??
                              'Unavailable'
                          : formatHours(volunteerInformation.availabilities.monday),
                    ),
                    volunteer_information_widget(
                      title: AppLocalizations.of(context)?.volunteer_availability_tuesday ??
                          'Availability Tuesday',
                      content: volunteerInformation.availabilities.tuesday.isEmpty
                          ? AppLocalizations.of(context)?.unavailable ??
                              'Unavailable'
                          : formatHours(volunteerInformation.availabilities.tuesday),
                    ),
                    volunteer_information_widget(
                      title: AppLocalizations.of(context)?.volunteer_availability_wednesday ??
                          'Availability Wednesday',
                      content: volunteerInformation.availabilities.wednesday.isEmpty
                          ? AppLocalizations.of(context)?.unavailable ??
                              'Unavailable'
                          : formatHours(volunteerInformation.availabilities.wednesday),
                    ),
                    volunteer_information_widget(
                      title: AppLocalizations.of(context)?.volunteer_availability_thursday ??
                          'Availability Thursday',
                      content: volunteerInformation.availabilities.thursday.isEmpty
                          ? AppLocalizations.of(context)?.unavailable ??
                              'Unavailable'
                          : formatHours(volunteerInformation.availabilities.thursday),
                    ),
                    volunteer_information_widget(
                      title: AppLocalizations.of(context)?.volunteer_availability_friday ??
                          'Availability Friday',
                      content: volunteerInformation.availabilities.friday.isEmpty
                          ? AppLocalizations.of(context)?.unavailable ??
                              'Unavailable'
                          : formatHours(volunteerInformation.availabilities.friday),
                    ),
                    volunteer_information_widget(
                      title: AppLocalizations.of(context)?.volunteer_availability_saturday ??
                          'Availability Saturday',
                      content: volunteerInformation.availabilities.saturday.isEmpty
                          ? AppLocalizations.of(context)?.unavailable ??
                              'Unavailable'
                          : formatHours(volunteerInformation.availabilities.saturday),
                    ),
                    volunteer_information_widget(
                      title: AppLocalizations.of(context)?.volunteer_availability_sunday ??
                          'Availability Sunday',
                      content: volunteerInformation.availabilities.sunday.isEmpty
                          ? AppLocalizations.of(context)?.unavailable ??
                              'Unavailable'
                          : formatHours(volunteerInformation.availabilities.sunday),
                    ),
                   ],
                ),
              );
            },
          ),

    );

  }


    }

