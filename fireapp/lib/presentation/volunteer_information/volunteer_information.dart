import 'dart:convert';

import 'package:fireapp/base/spaced_by.dart';
import 'package:fireapp/base/widget.dart';
import 'package:fireapp/domain/models/volunteer_information.dart';
import 'package:fireapp/layout/wrapper.dart';
import 'package:fireapp/presentation/change_roles/change_roles_page.dart';
import 'package:fireapp/presentation/fireapp_page.dart';
import 'package:fireapp/presentation/volunteer_information/volunteer_information_viewmodel.dart';
import 'package:fireapp/presentation/volunteer_information/VolunteerInformationWidget.dart';
import 'package:fireapp/widgets/fireapp_app_bar.dart';
import 'package:fireapp/widgets/request_state_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fireapp/presentation/volunteer_information/VolunteerInformationWidget.dart';

import '../change_qualification/change_qualification_page.dart';

class VolunteerInformationPage extends StatefulWidget {
  final String volunteerId;

  const VolunteerInformationPage({
    super.key,
    required this.volunteerId,
  });

  @override
  State createState() => _VolunteerInformationState();
}

class _VolunteerInformationState
    extends FireAppState<VolunteerInformationPage>
    implements ViewModelHolder<VolunteerInformationViewModel> {
  String getAvailabilityMessage(BuildContext context, List<List<double>> availability) {
    if (availability.isEmpty) {
      return AppLocalizations.of(context)?.unavailable ?? 'Unavailable';
    } else {
      return formatHours(availability);
    }
  }
  String formatHours(List<List<double>> hours) {
    return hours.map((hourRange) => '${formatHour(hourRange[0])} to ${formatHour(hourRange[1])}').join(', ');
  }

  String formatHour(double hour) {
    if (hour == 0) {
      return '12am';
    } else if (hour < 12) {
      return '${hour.floor()}' + 'am';
    } else if (hour == 12) {
      return '12pm';
    } else {
      return '${hour.floor() - 12}' + 'pm';
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
      appBar: fireAppAppBar(context,
        AppLocalizations.of(context)?.volunteerInformationTitle ??
            'Volunteer Information',
      ),
        body: RequestStateWidget.stream<VolunteerInformation>(
            state: viewModel.volunteerInformation,
            retry: () => viewModel.getVolunteerInformation(widget.volunteerId),
            child: (_, volunteerInformation) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildContainer(
                          VolunteerInformationWidget(
                            title: AppLocalizations.of(context)?.volunteer_id ?? 'ID',
                            content: volunteerInformation.ID,
                          )
                      ),
                      _buildContainer(
                          VolunteerInformationWidget(
                            title: AppLocalizations.of(context)?.volunteer_name ?? 'Name',
                            content: "${volunteerInformation.firstName} ${volunteerInformation.lastName}",
                          )
                      ),
                      _buildContainer(
                          VolunteerInformationWidget(
                            title: AppLocalizations.of(context)?.volunteer_email ?? 'Email',
                            content: volunteerInformation.email,
                          )
                      ),
                      _buildContainer(
                          VolunteerInformationWidget(
                            title: AppLocalizations.of(context)?.volunteer_phone ?? 'Phone',
                            content: volunteerInformation.mobileNo,
                          )
                      ),
                      _buildContainer(
                          VolunteerInformationWidget(
                            title: AppLocalizations.of(context)?.volunteer_prefHours ??
                                'Preferred Hours',
                            content: volunteerInformation.prefHours.toString(),
                          )
                      ),
                      _buildContainer(
                          VolunteerInformationWidget(
                            title: AppLocalizations.of(context)?.volunteer_expYears ??
                                'Experience Years',
                            content: volunteerInformation.expYears.toString(),
                          )
                      ),
                      _buildContainer(
                          GestureDetector(
                              onTap: () => Navigator.push(context, MaterialPageRoute(
                                builder: (context) => ChangeQualificationsPage(
                                  volunteerId: widget.volunteerId,
                                  qualifications: volunteerInformation.qualifications,
                              )
                          )),
                          child: VolunteerInformationWidget(
                            title: AppLocalizations.of(context)?.volunteer_qualifications ??
                                'Qualifications',
                            content: volunteerInformation.qualifications.map((qualification) => qualification.name)
                                .join('\n'),
                          )
                          )
                      ),
                      _buildContainer(
                          GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(
                              builder: (context) => ChangeRolesPage(
                                volunteerId: widget.volunteerId,
                                roles: volunteerInformation.possibleRoles,
                              )
                            )),
                            child: VolunteerInformationWidget(
                              title: AppLocalizations.of(context)?.volunteer_possibleRoles ??
                                  'Possible Roles',
                              content: volunteerInformation.possibleRoles.map((role) => role)
                                  .join('\n'),
                            ),
                          )

                      ),
                      _buildContainer(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)?.volunteer_availability ?? 'Availability',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.normal
                                ),
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
                          )
                      )
                    ].spacedBy(8),
                  ),
                ),
              );
            },
        ),
    );
  }

  Widget _buildContainer(Widget child) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
      ),
      child: child,
    );
  }

}

