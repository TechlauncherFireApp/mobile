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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)?.volunteer_id(volunteerInformation.ID) ??
                          'Volunteer ID',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      AppLocalizations.of(context)?.volunteer_first_name(volunteerInformation.firstName) ??
                          'Volunteer First Name',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      AppLocalizations.of(context)?.volunteer_last_name(volunteerInformation.lastName) ??
                          'Volunteer Last Name',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      AppLocalizations.of(context)?.volunteer_email(volunteerInformation.email) ??
                          'Volunteer Email',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      AppLocalizations.of(context)?.volunteer_phone(volunteerInformation.mobileNo) ??
                          'Volunteer Phone',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      AppLocalizations.of(context)?.volunteer_prefHours(volunteerInformation.prefHours) ??
                          'Volunteer Preferred Hours',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      AppLocalizations.of(context)?.volunteer_expYears(volunteerInformation.expYears) ??
                          'Volunteer Experience Years',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      AppLocalizations.of(context)?.volunteer_qualifications(
                        volunteerInformation.qualifications.map((q) =>
                          q.name
                        ).toList().join(', ')
                      ) ?? 'Volunteer Qualifications',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: volunteerInformation.possibleRoles
                          .map((role) => Text(AppLocalizations.of(context)?.volunteer_possibleRoles(role) ?? role,
                              style: Theme.of(context).textTheme.bodyMedium,
                           ))
                          .toList(),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)?.volunteer_availability_monday(volunteerInformation.availabilities.monday) ?? 'Volunteer Availabilities',
                        ),
                        Text(
                          AppLocalizations.of(context)?.volunteer_availability_tuesday(volunteerInformation.availabilities.tuesday) ?? 'Volunteer Availabilities',
                        ),
                        Text(
                          AppLocalizations.of(context)?.volunteer_availability_wednesday(volunteerInformation.availabilities.wednesday) ?? 'Volunteer Availabilities',
                        ),
                        Text(
                          AppLocalizations.of(context)?.volunteer_availability_thursday(volunteerInformation.availabilities.thursday) ?? 'Volunteer Availabilities',
                        ),
                        Text(
                          AppLocalizations.of(context)?.volunteer_availability_friday(volunteerInformation.availabilities.friday) ?? 'Volunteer Availabilities',
                        ),
                        Text(
                          AppLocalizations.of(context)?.volunteer_availability_saturday(volunteerInformation.availabilities.saturday) ?? 'Volunteer Availabilities',
                        ),
                        Text(
                          AppLocalizations.of(context)?.volunteer_availability_sunday(volunteerInformation.availabilities.sunday) ?? 'Volunteer Availabilities',
                        ),
                      ],
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