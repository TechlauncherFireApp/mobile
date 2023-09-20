import 'package:fireapp/presentation/constraint_form/constraint_form_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:fireapp/domain/models/reference/asset_type.dart';

void main() {
  late SchedulerConstraintFormViewModel viewModel;

  setUp(() {
    viewModel = SchedulerConstraintFormViewModel();
  });

  group('ConstraintFormViewModel', () {
    test('dispose throws nothing', () {
      viewModel.dispose();
    });
  });
}
