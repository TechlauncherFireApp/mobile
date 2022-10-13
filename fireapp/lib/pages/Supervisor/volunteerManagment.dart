import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
//FireApp Files
import 'package:fireapp/global/constants.dart' as constants; //API URL
import 'package:fireapp/global/access.dart';

class VolunteerList extends StatefulWidget {
  const VolunteerList({super.key});

  @override
  State<VolunteerList> createState() => _VolunteerListState();
}

class _VolunteerListState extends State<VolunteerList> {
  late Future<List<VolunteerAlbum>> _volunteerData;

  @override
  void initState() {
    _volunteerData = volunteerListRequest(); // API Request - See Calendar_Logic.dart

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('List of Volunteers'),
          automaticallyImplyLeading: false),
      body: FutureBuilder(
        future: _volunteerData, //Data from API Request
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (content, index){
                print(snapshot.data);
                return buildVolunteerCard(snapshot.data[index].id, snapshot.data[index].name);
              },
            ); 
          }
          else {
            print('error');
            print(snapshot);
            return Container();
          }
        }, 
      ), 
    );
  }
}

Widget buildVolunteerCard(String id, String name){
  return Card(
    child: ListTile(
      // onTap: () {}
      title: Text(name), //Take NAME FROM API
      subtitle: Row(
        children: [
          const Text("ID: "),
          Text(id), // Take ID FROM API
        ],
      ),
      leading: CircleAvatar(
        backgroundColor: Colors.amber,
        child: Text(name[0]), //Have a function to take first letter from name from API 
      ),
      onTap: () {}, //Take you to volunteers info page...
    ),
  );
}

/// LOGIC /// 

/*
* @Desc - Volunteer Event object 
*/
class VolunteerAlbum {
  // Properties
  final String id;
  final String name; 

  // Constructor
  const VolunteerAlbum({
    required this.id,
    required this.name,
  });
}

/*
* @DESC - Return a list of volunteers from the API response
* @PARAM - API Response
* @RETURN - List of Volunteer Objects that have id and name
*/
List<VolunteerAlbum> parseVolunteers(String responseBody) {
  final parsed = LinkedHashMap.from(jsonDecode(responseBody));
  List<VolunteerAlbum> result = []; 

  parsed.forEach((key, value) {
    result.add(VolunteerAlbum(id: key, name: value)); 
  }); 

  return result; 
}

Future<List<VolunteerAlbum>> volunteerListRequest() async {
  String apiPath =
      'user/getAllVolunteer'; //Specific API path for this request

  var url = Uri.https(
      constants.domain, apiPath); //Completed HTTPS URL

  final response = await http.get(url); //the GET Request

  //Check if request successful else print url + errorcode
  if (response.statusCode == 200) {
    print('200');
    print(url);
  } else {
    print(response.statusCode);
    print(url);
  }
  return compute(parseVolunteers, response.body); 
  //Return the request reponse
}

