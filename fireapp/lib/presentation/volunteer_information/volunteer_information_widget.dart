import 'dart:convert';

import 'package:fireapp/base/widget.dart';
import 'package:fireapp/domain/models/volunteer_information.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/models/reference/qualification.dart';

class volunteer_information_widget extends StatelessWidget {
  final String? title;
  final String? content;

  const volunteer_information_widget({super.key, this.title, this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title ?? '',
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium,
              textAlign: TextAlign.left,
            ),
            Expanded(
              child: Text(
                content ?? '',
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
       ],
     );
  }
}