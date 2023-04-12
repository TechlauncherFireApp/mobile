import 'dart:convert';

import 'package:fireapp/base/widget.dart';
import 'package:fireapp/domain/models/volunteer_information.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/models/reference/qualification.dart';

class VolunteerInformationWidget extends StatelessWidget {
  final String? title;
  final String? content;

  const VolunteerInformationWidget({super.key, this.title, this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title ?? '',
              style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium,
              textAlign: TextAlign.left,
            ),
            const SizedBox(width: 24,),
            Expanded(
              child: Text(
                content ?? '',
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyLarge,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
       ],
     );
  }
}