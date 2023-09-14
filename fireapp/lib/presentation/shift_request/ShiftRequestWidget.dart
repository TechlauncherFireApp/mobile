import 'package:fireapp/style/theme.dart';
import 'package:flutter/material.dart';

class ShiftRequestWidget extends StatelessWidget {
  final String? title;
  final String? content;

  const ShiftRequestWidget({Key? key, this.title, this.content}) : super(key: key);

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
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.left,
            ),
            SizedBox(width: 1.5.rdp(),),
            Expanded(
              child: Text(
                content ?? '',
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
