import 'dart:async';
import 'package:fireapp/domain/repository/scheduler_constraint_form_repository.dart';
import 'package:fireapp/presentation/fireapp_view_model.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/models/reference/asset_type.dart';
import '../../domain/request_state.dart';
import '../../global/di.dart';

class SchedulerConstraintFormViewModel extends FireAppViewModel {
  late final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late final SchedulerConstraintFormRepository
      _schedulerConstraintFormRepository;

  // Text Editing Controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController inputDateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();

  // Remove this after actual thing implemented
  // coverage:ignore-start

  final BehaviorSubject<List<AssetType>> _assetTypes =
      BehaviorSubject<List<AssetType>>();
  Stream<List<AssetType>> get assetsStream => _assetTypes.stream;

  // Current dropdown value
  int dropdownValue = 1;

  // Function to be called when the form is submitted
  void submit(int id, String name, String code, DateTime updated,
      DateTime created) async {
    try {
      await _schedulerConstraintFormRepository.getAssetType(
          id, name, code, updated, created);
      _assetTypes.add(RequestState.success(null) as List<AssetType>);
    } catch (e) {
      logger.e(e);
      _assetTypes.add(RequestState.exception(e) as List<AssetType>);
    }
  }

  @override
  Future<void> dispose() async {
    titleController.dispose();
    inputDateController.dispose();
    startTimeController.dispose();
    _assetTypes.close();
  }
}
