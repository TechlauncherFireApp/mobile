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
        body: BasicWrapper(
          page: RequestStateWidget.stream<VolunteerInformation>(
            state: viewModel.volunteerInformation,
            retry: () => viewModel.getVolunteerInformation(widget.volunteerId),
            child: (_, volunteerInformation) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)?.volunteer_id ?? 'Volunteer ID',
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium,
                          textAlign: TextAlign.left,
                        ),
                        Expanded(
                          child: Text(
                            volunteerInformation.ID,
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyMedium,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)?.volunteer_first_name ??
                              'Volunteer First Name',
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium,
                          textAlign: TextAlign.left,
                        ),
                        Expanded(
                          child: Text(
                            volunteerInformation.firstName,
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyMedium,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)?.volunteer_last_name ??
                              'Volunteer Last Name',
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium,
                          textAlign: TextAlign.left,
                        ),
                        Expanded(
                          child: Text(
                            volunteerInformation.lastName,
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyMedium,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)?.volunteer_email ??
                              'Volunteer Email',
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium,
                          textAlign: TextAlign.left,
                        ),
                        Expanded(
                          child: Text(
                            volunteerInformation.email,
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyMedium,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)?.volunteer_phone ??
                              'Volunteer Phone',
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium,
                          textAlign: TextAlign.left,
                        ),
                        Expanded(
                          child: Text(
                            volunteerInformation.mobileNo,
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyMedium,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)?.volunteer_prefHours ??
                              'Volunteer Preferred Hours',
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium,
                          textAlign: TextAlign.left,
                        ),
                        Expanded(
                          child: Text(
                            "${volunteerInformation.prefHours}",
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                          AppLocalizations.of(context)?.volunteer_expYears ??
                          'Volunteer Experience',
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyMedium,
                            textAlign: TextAlign.left,
                          ),
                          Expanded(
                            child: Text(
                              "${volunteerInformation.expYears}",
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyMedium,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),

                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)?.volunteer_possibleRoles ??
                                'Volunteer Possible Roles',
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyMedium,
                            textAlign: TextAlign.left,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: "${volunteerInformation.possibleRoles}"
                                  .substring(1, "${volunteerInformation.possibleRoles}".length - 1)
                                  .split(", ")
                                  .map((role) => Text(
                                role,
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.right,
                              ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)?.volunteer_qualifications ??
                                'Volunteer Qualifications',
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyMedium,
                            textAlign: TextAlign.left,
                          ),
                          Expanded(
                            child: Text(
                              volunteerInformation.qualifications
                                  .map((qualification) => qualification.name)
                                  .join('\n'),
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)?.volunteer_availability_monday
                              ??
                              'Volunteer Availability Monday',
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium,
                          textAlign: TextAlign.left,
                        ),
                        Expanded(
                          child: Text(
                            volunteerInformation.availabilities.monday.isEmpty
                                ? AppLocalizations.of(context)?.unavailable ?? 'Unavailable'
                                : formatHours(volunteerInformation.availabilities.monday),
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyMedium,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                        AppLocalizations.of(context)?.volunteer_availability_tuesday??
                        'Volunteer Availability Tuesday',
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium,
                          textAlign: TextAlign.left,
                        ),
                        Expanded(
                          child: Text(
                            volunteerInformation.availabilities.tuesday.isEmpty
                            ? AppLocalizations.of(context)?.unavailable ?? 'Unavailable'
                                : formatHours(volunteerInformation.availabilities.tuesday),
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyMedium,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)?.volunteer_availability_wednesday
                          ??
                          'Volunteer Availability Wednesday',
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium,
                          textAlign: TextAlign.left,
                        ),
                        Expanded(
                          child: Text(
                            volunteerInformation.availabilities.wednesday.isEmpty
                                ? AppLocalizations.of(context)?.unavailable ?? 'Unavailable'
                                : formatHours(volunteerInformation.availabilities.wednesday),
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyMedium,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)?.volunteer_availability_thursday
                            ?? 'Volunteer Availability Thursday',
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium,
                          textAlign: TextAlign.left,
                        ),
                        Expanded(
                          child: Text(
                            volunteerInformation.availabilities.thursday.isEmpty
                                ? AppLocalizations.of(context)?.unavailable ?? 'Unavailable'
                                : formatHours(volunteerInformation.availabilities.thursday),
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyMedium,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)?.volunteer_availability_friday
                          ??
                          'Volunteer Availability Friday',
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium,
                          textAlign: TextAlign.left,
                        ),
                        Expanded(
                          child: Text(
                            volunteerInformation.availabilities.friday.isEmpty
                                ? AppLocalizations.of(context)?.unavailable ?? 'Unavailable'
                                : formatHours(volunteerInformation.availabilities.friday),
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyMedium,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)?.volunteer_availability_saturday??
                          'Volunteer Availability Saturday',
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium,
                          textAlign: TextAlign.left,
                        ),
                        Expanded(
                          child: Text(
                            volunteerInformation.availabilities.saturday.isEmpty
                                ? AppLocalizations.of(context)?.unavailable ?? 'Unavailable'
                                : formatHours(volunteerInformation.availabilities.saturday),
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyMedium,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)?.volunteer_availability_sunday??
                          'Volunteer Availability Sunday',
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium,
                          textAlign: TextAlign.left,
                        ),
                        Expanded(
                          child: Text(
                            volunteerInformation.availabilities.sunday.isEmpty
                                ? AppLocalizations.of(context)?.unavailable ?? 'Unavailable'
                                : formatHours(volunteerInformation.availabilities.sunday),
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyMedium,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
    );

  }


    }