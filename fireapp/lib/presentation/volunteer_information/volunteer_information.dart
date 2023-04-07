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
        child: (_, volunteerInformation){
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${volunteerInformation.name}'),
                Text('Email: ${volunteerInformation.email}'),
                Text('Mobile No: ${volunteerInformation.mobileNo}'),
                Text('Preferred Hours: ${volunteerInformation.prefHours}'),
                Text('Experience Years: ${volunteerInformation.expYears}'),
                Text('Qualifications: ${volunteerInformation.qualifications.join(", ")}'),
                Text('Availabilities:'),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Monday: ${volunteerInformation.availabilities.monday.join(", ")}'),
                    Text('Tuesday: ${volunteerInformation.availabilities.tuesday.join(", ")}'),
                    Text('Wednesday: ${volunteerInformation.availabilities.wednesday.join(", ")}'),
                    Text('Thursday: ${volunteerInformation.availabilities.thursday.join(", ")}'),
                    Text('Friday: ${volunteerInformation.availabilities.friday.join(", ")}'),
                    Text('Saturday: ${volunteerInformation.availabilities.saturday.join(", ")}'),
                    Text('Sunday: ${volunteerInformation.availabilities.sunday.join(", ")}'),
                  ],
                ),
                Text('Possible Roles: ${volunteerInformation.possibleRoles.join(", ")}'),
              ],
          );
        }
      )
    );
  }
}