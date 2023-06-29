import 'package:fireapp/layout/wrapper.dart';
import 'package:fireapp/presentation/dietary_requirements/dietary_requirements_widget.dart';
import 'package:fireapp/widgets/fireapp_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DietaryRequirementsPage extends StatelessWidget {
  const DietaryRequirementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: fireAppAppBar(context, "Dietary Requirements"),
      resizeToAvoidBottomInset: false,
      body: const Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: DietaryRequirementsWidget(),
      ),
    );
  }

}