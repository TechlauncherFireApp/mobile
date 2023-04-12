import 'package:fireapp/data/persistence/authentication_persistence.dart';
import 'package:fireapp/domain/models/token_response.dart';
import 'package:fireapp/global/access.dart';
import 'package:flutter/material.dart';
import 'package:fireapp/global/constants.dart' as constants; //API URL
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fireapp/layout/dialog.dart';
import 'package:fireapp/layout/loading.dart';

enum LoginResult { success, fail, networkError, timeout }
