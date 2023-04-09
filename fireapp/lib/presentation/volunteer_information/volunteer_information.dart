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

  @override
  VolunteerInformationViewModel viewModel = GetIt.instance.get();

  @override
  void initState() {
    super.initState();
    viewModel.getVolunteerInformation(widget.volunteerId);
  }

  @override
  Widget build(BuildContext context) {
    return BasicWrapper(
      page: RequestStateWidget.stream<VolunteerInformation>(
        state: viewModel.volunteerInformation,
        retry: () => viewModel.getVolunteerInformation(widget.volunteerId),
        child: (_, volunteerInformation) {
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Volunteer ID:",
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium,
                      textAlign: TextAlign.left,
                    ),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)?.volunteer_id(
                        volunteerInformation.ID) ??
                        'Volunteer ID',
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
                      "Volunteer First Name:",
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium,
                      textAlign: TextAlign.left,
                    ),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)?.volunteer_first_name(
                            volunteerInformation.firstName) ??
                            'Volunteer First Name',
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
                      "Volunteer Last Name:",
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium,
                      textAlign: TextAlign.left,
                    ),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)?.volunteer_last_name(
                            volunteerInformation.lastName) ??
                            'Volunteer Last Name',
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
                      "Volunteer Email:",
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium,
                      textAlign: TextAlign.left,
                    ),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)?.volunteer_email(
                            volunteerInformation.email) ??
                            'Volunteer Email',
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
                      'Volunteer Phone:',
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium,
                      textAlign: TextAlign.left,
                    ),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)?.volunteer_phone(
                            volunteerInformation.mobileNo) ??
                            'Volunteer Phone',
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
                      'Volunteer Preference Hour:',
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium,
                      textAlign: TextAlign.left,
                    ),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)?.volunteer_prefHours(
                            volunteerInformation.prefHours) ??
                            'Volunteer Address',
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodyMedium,
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
                          'Volunteer Experience:',
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium,
                          textAlign: TextAlign.left,
                        ),
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)?.volunteer_expYears(
                                volunteerInformation.expYears) ??
                                'Volunteer Experience',
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
                        'Volunteer Possible Roles:',
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodyMedium,
                        textAlign: TextAlign.left,
                      ),
                      Expanded(
                        child: Text(
                          (AppLocalizations.of(context)?.volunteer_possibleRoles
                            (volunteerInformation.possibleRoles)
                              ?? 'Volunteer Possible Roles')
                              .toString()
                              .replaceAll('[', '')
                              .replaceAll(',', '\n')
                              .replaceAll(']', ''),

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
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Volunteer Qualifications:',
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodyMedium,
                        textAlign: TextAlign.left,
                      ),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)?.volunteer_qualifications(
                              volunteerInformation.qualifications.map((q) =>
                              q.name
                              )
                                  .toList()
                                  .toString()
                                  .replaceAll('[', '')
                                  .replaceAll(',', '\n')
                                  .replaceAll(']', '')
                          ) ?? 'Volunteer Qualifications',
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Monday:',
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium,
                      textAlign: TextAlign.left,
                    ),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)?.volunteer_availability_monday(
                            volunteerInformation.availabilities.monday.isEmpty
                                ? 'Unavailable'
                                : volunteerInformation.availabilities.monday)
                            .replaceFirst('[', '')
                            .replaceFirst(']]', ']')
                            ??
                            'Volunteer Availability Monday',
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
                      'Tuesday:',
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium,
                      textAlign: TextAlign.left,
                    ),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)?.volunteer_availability_tuesday(
                            volunteerInformation.availabilities.tuesday.isEmpty ? 'Unavailable'
                                : volunteerInformation.availabilities.tuesday)
                            .replaceFirst('[', '')
                            .replaceFirst(']]', ']')??
                            'Volunteer Availability Tuesday',
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
                      'Wednesday:',
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium,
                      textAlign: TextAlign.left,
                    ),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)?.volunteer_availability_wednesday(
                            volunteerInformation.availabilities.wednesday.isEmpty ? 'Unavailable'
                                : volunteerInformation.availabilities.wednesday)
                            .replaceFirst('[', '')
                            .replaceFirst(']]', ']')??
                            'Volunteer Availability Wednesday',
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
                      'Thursday:',
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium,
                      textAlign: TextAlign.left,
                    ),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)?.volunteer_availability_thursday(
                            volunteerInformation.availabilities.thursday.isEmpty ? 'Unavailable'
                                : volunteerInformation.availabilities.thursday)
                            .replaceFirst('[', '')
                            .replaceFirst(']]', ']')??
                            'Volunteer Availability Thursday',
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
                      'Friday:',
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium,
                      textAlign: TextAlign.left,
                    ),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)?.volunteer_availability_friday(
                            volunteerInformation.availabilities.friday.isEmpty ? 'Unavailable'
                                : volunteerInformation.availabilities.friday)
                            .replaceFirst('[', '')
                            .replaceFirst(']]', ']')
                            ??
                            'Volunteer Availability Friday',
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
                      'Saturday:',
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium,
                      textAlign: TextAlign.left,
                    ),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)?.volunteer_availability_saturday(
                            volunteerInformation.availabilities.saturday.isEmpty ? 'Unavailable'
                                : volunteerInformation.availabilities.saturday)
                            .replaceFirst('[', '')
                            .replaceFirst(']]', ']')??
                            'Volunteer Availability Saturday',
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
                      'Sunday:',
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium,
                      textAlign: TextAlign.left,
                    ),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)?.volunteer_availability_sunday(
                            volunteerInformation.availabilities.sunday.isEmpty ? 'Unavailable'
                                : volunteerInformation.availabilities.sunday)
                            .replaceFirst('[', '')
                            .replaceFirst(']]', ']')??
                            'Volunteer Availability Sunday',
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
    );
  }


    }