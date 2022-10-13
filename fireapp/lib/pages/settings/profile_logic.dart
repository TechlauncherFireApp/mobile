import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//FIREAPP FILES IMPORT
import 'package:fireapp/global/constants.dart' as constants; //API URL
import 'package:fireapp/global/access.dart';

/*
* @DESC - Provides id of logged in user as a string
*/
String getID() {
  return userId.toString(); 
} 

/*
* @DESC
* @PARAM - user id, parameter: 'first name', 'last name', 'gender', 'email', 'mobile_number',
*    'roles', 'dietary', 'allergy'
* @RETURN Information about the users specific parameter 
*/
Future<List<String>> profileRequest(String id, List<String> parameters) async {
  //http.Client client
  String apiPath =
      'profile/getProfile'; //Specific API path for this request
  Map<String, String> queryParameters = {
    'userId': id,
  }; //API Query parameters

  var url = Uri.https(
      constants.domain, apiPath, queryParameters); //Completed HTTPS URL

  final response = await http.post(url,
      body: json.encode({
        "id" : id,
      })); // The API request

  //Check if request successful else print url + errorcode
  if (response.statusCode == 200) {
    print('200');
    print(url);
  } else {
    print(response.statusCode);
    print(url);
  }

  //Return specfic parameters
  final tmp = Map.from(json.decode(response.body)); 
  List<String> result = []; 
  for(String parameter in parameters) {

    result.add(tmp[parameter]);
  }

  //Return the request reponse
  print(result);
  return result;
}

/*
* @DESC - Change a profile detail (Note currently does not work with email because email linked to login)
* @PARAM - user id, parameter: 'phone', 'gender', 'dietary', 'allergy', newParam - what you want to update the parameter with
* @RETURN Information about the users specific parameter 
*/
Future<void> profileUpdate(String id, parameter, newParam) async {
  //http.Client client
  String apiPath =
      'profile/editProfile'; //Specific API path for this request
  Map<String, String> queryParameters = {
    'userId': id,
  }; //API Query parameters

  var url = Uri.https(
      constants.domain, apiPath, queryParameters); //Completed HTTPS URL

  final response = await http.post(url,
      body: json.encode({
        "id" : id,
        parameter : newParam, 
      })); // The API request

  //Check if request successful else print url + errorcode
  if (response.statusCode == 200) {
    print('200');
    print(url);
  } else {
    print(response.statusCode);
    print(url);
  }
}