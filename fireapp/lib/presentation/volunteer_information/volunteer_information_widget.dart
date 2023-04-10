import 'dart:convert';

import 'package:fireapp/base/widget.dart';
import 'package:fireapp/domain/models/volunteer_information.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/models/reference/qualification.dart';

class volunteer_information_widget extends StatelessWidget {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final int? prefHours;
  final int? expYears;
  final List<Qualification>? qualifications;
  final AvailabilityField availabilities;
  final List<String>? possibleRoles;

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

  const volunteer_information_widget({super.key, this.id, this.firstName, this.lastName, this.email, this.phoneNumber, this.prefHours, this.expYears, this.qualifications, required this.availabilities, this.possibleRoles});

  @override
  Widget build(BuildContext context) {
    String volunteerId = AppLocalizations
        .of(context)
        ?.volunteer_id ?? 'Volunteer ID';
    String volunteerFirstName = AppLocalizations
        .of(context)
        ?.volunteer_first_name ??
        'Volunteer First Name';
    String volunteerLastName = AppLocalizations
        .of(context)
        ?.volunteer_last_name ??
        'Volunteer Last Name';
    String volunteerEmail = AppLocalizations
        .of(context)
        ?.volunteer_email ?? 'Volunteer Email';
    String volunteerPhoneNumber = AppLocalizations
        .of(context)
        ?.volunteer_phone ?? 'Volunteer Phone Number';
    String volunteerPrefHours = AppLocalizations
        .of(context)
        ?.volunteer_prefHours ?? 'Volunteer Preferred Hours';
    String volunteerExpYears = AppLocalizations
        .of(context)
        ?.volunteer_expYears?? 'Volunteer Experience Years';
    String volunteerPossibleRoles = AppLocalizations
        .of(context)
        ?.volunteer_possibleRoles ?? 'Volunteer Possible Roles';
    String volunteerQualifications = AppLocalizations
        .of(context)
        ?.volunteer_qualifications ?? 'Volunteer Qualifications';
    String volunteerAvailabilitiesMonday = AppLocalizations
        .of(context)
        ?.volunteer_availability_monday ?? 'Volunteer Availabilities Monday';
    String volunteerAvailabilitiesTuesday = AppLocalizations
        .of(context)
        ?.volunteer_availability_tuesday ?? 'Volunteer Availabilities Tuesday';
    String volunteerAvailabilitiesWednesday = AppLocalizations
        .of(context)
        ?.volunteer_availability_wednesday ?? 'Volunteer Availabilities Wednesday';
    String volunteerAvailabilitiesThursday = AppLocalizations
        .of(context)
        ?.volunteer_availability_thursday ?? 'Volunteer Availabilities Thursday';
    String volunteerAvailabilitiesFriday = AppLocalizations
        .of(context)
        ?.volunteer_availability_friday ?? 'Volunteer Availabilities Friday';
    String volunteerAvailabilitiesSaturday = AppLocalizations
        .of(context)
        ?.volunteer_availability_saturday ?? 'Volunteer Availabilities Saturday';
    String volunteerAvailabilitiesSunday = AppLocalizations
        .of(context)
        ?.volunteer_availability_sunday ?? 'Volunteer Availabilities Sunday';
    String unavailable = AppLocalizations
        .of(context)
        ?.unavailable ?? 'Unavailable';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              volunteerId,
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium,
              textAlign: TextAlign.left,
            ),
            Expanded(
              child: Text(
                id ?? '',
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              volunteerFirstName,
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium,
              textAlign: TextAlign.left,
            ),
            Expanded(
              child: Text(
                firstName ?? '',
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              volunteerLastName,
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium,
              textAlign: TextAlign.left,
            ),
            Expanded(
              child: Text(
                lastName ?? '',
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              volunteerEmail,
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium,
              textAlign: TextAlign.left,
            ),
            Expanded(
              child: Text(
                email ?? '',
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              volunteerPhoneNumber,
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium,
              textAlign: TextAlign.left,
            ),
            Expanded(
              child: Text(
                phoneNumber ?? '',
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              volunteerPrefHours,
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium,
              textAlign: TextAlign.left,
            ),
            Expanded(
              child: Text(
                prefHours.toString() ?? '',
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              volunteerExpYears,
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium,
              textAlign: TextAlign.left,
            ),
            Expanded(
              child: Text(
                expYears.toString() ?? '',
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              volunteerPossibleRoles,
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium,
              textAlign: TextAlign.left,
            ),
            Expanded(
              child: Text(
                possibleRoles.toString().substring(1, possibleRoles.toString().length - 1)
                    .split(",")
                    .join("\n"),
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              volunteerQualifications,
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium,
              textAlign: TextAlign.left,
            ),
            Expanded(
              child: Text(
                qualifications?.map((qualification) => qualification.name)
                  .join('\n') ?? '',
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              volunteerAvailabilitiesMonday,
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium,
              textAlign: TextAlign.left,
            ),
            Expanded(
              child: Text(
                availabilities.monday.isEmpty  ? unavailable ?? ''
                : formatHours(availabilities.monday) ?? '',
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              volunteerAvailabilitiesTuesday,
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium,
              textAlign: TextAlign.left,
            ),
            Expanded(
              child: Text(
                availabilities.tuesday.isEmpty  ? unavailable ?? ''
                : formatHours(availabilities.tuesday) ?? '',
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              volunteerAvailabilitiesWednesday,
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium,
              textAlign: TextAlign.left,
            ),
            Expanded(
              child: Text(
                availabilities.wednesday.isEmpty  ? unavailable ?? ''
                : formatHours(availabilities.wednesday) ?? '',
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              volunteerAvailabilitiesThursday,
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium,
              textAlign: TextAlign.left,
            ),
            Expanded(
              child: Text(
                availabilities.thursday.isEmpty  ? unavailable ?? ''
                : formatHours(availabilities.thursday) ?? '',
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              volunteerAvailabilitiesFriday,
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium,
              textAlign: TextAlign.left,
            ),
            Expanded(
              child: Text(
                availabilities.friday.isEmpty  ? unavailable ?? ''
                : formatHours(availabilities.friday) ?? '',
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              volunteerAvailabilitiesSaturday,
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium,
              textAlign: TextAlign.left,
            ),
            Expanded(
              child: Text(
                availabilities.saturday.isEmpty  ? unavailable ?? ''
                : formatHours(availabilities.saturday) ?? '',
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              volunteerAvailabilitiesSunday,
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium,
              textAlign: TextAlign.left,
            ),
            Expanded(
              child: Text(
                availabilities.sunday.isEmpty  ? unavailable ?? ''
                : formatHours(availabilities.sunday) ?? '',
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
    );
  }
}