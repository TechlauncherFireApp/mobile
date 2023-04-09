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
                SizedBox(height: 12.0),
                Text(
                  'Volunteer Information',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 12.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Volunteer ID: ${volunteerInformation.ID}',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      'Volunteer Name: ${volunteerInformation.firstName} ${volunteerInformation.lastName}',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      'Volunteer Email: ${volunteerInformation.email}',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      'Volunteer Mobile No: ${volunteerInformation.mobileNo}',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      'Volunteer Preferred Hours: ${volunteerInformation.prefHours}',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      'Volunteer Experience Years: ${volunteerInformation.expYears}',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 12.0),
                    Text('Volunteer Possible Roles: ${volunteerInformation.possibleRoles.join(", ")}',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      'Volunteer Qualifications: ${volunteerInformation.qualifications.join(", ")}',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      'Volunteer Availabilities:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 12.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Monday: ${volunteerInformation.availabilities.Monday?.join(", ")}',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,),
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          'Tuesday: ${volunteerInformation.availabilities.Tuesday?.join(", ")}',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,),
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          'Wednesday: ${volunteerInformation.availabilities.Wednesday?.join(", ")}',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,),
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          'Thursday: ${volunteerInformation.availabilities.Thursday?.join(", ")}',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,),
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          'Friday: ${volunteerInformation.availabilities.Friday?.join(", ")}',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,),
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          'Saturday: ${volunteerInformation.availabilities.Saturday?.join(", ")}',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,),
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          'Sunday: ${volunteerInformation.availabilities.Sunday?.join(", ")}',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,),
                        ),
                      ],
                    ),
          ],
          ),]);
        }
      )
    );
  }
}