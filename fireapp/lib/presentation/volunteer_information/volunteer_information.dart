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
                      id: volunteerInformation.ID,
                      firstName: volunteerInformation.firstName,
                      lastName: volunteerInformation.lastName,
                      email: volunteerInformation.email,
                      phoneNumber: volunteerInformation.mobileNo,
                      prefHours: volunteerInformation.prefHours,
                      expYears: volunteerInformation.expYears,
                      possibleRoles: volunteerInformation.possibleRoles,
                      qualifications: volunteerInformation.qualifications,
                      availabilities: volunteerInformation.availabilities,
                    ),
                   ],
                ),
              );
            },
          ),

    );

  }


    }