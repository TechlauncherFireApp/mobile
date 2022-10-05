import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class VolunteerList extends StatefulWidget {
  const VolunteerList({super.key});

  @override
  State<VolunteerList> createState() => _VolunteerListState();
}

class _VolunteerListState extends State<VolunteerList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('List of Volunteers'),
          automaticallyImplyLeading: false),
      body: Card(
        child: ListTile(
          // onTap: () {}
          title: Text('test'), //Take NAME FROM API
          subtitle: Row(
            children: [
              Text("ID: "),
              Text("7"), // Take ID FROM API
            ],
          ),
          leading: CircleAvatar(
            backgroundColor: Colors.amber,
            child: Text(
                'T'), //Have a function to take first letter from name from API -  can probably just do String[0]
          ),
          onTap: () {}, //Take you to volunteers info page...
        ),
      ),
    );
  }
}

/* 
FutureBuilder
if not loaded from api - do circle loading indicator
if loaded from api - do:
  ListView.builder
    from APIDate
    create Card w/ Name, CircleAvatar, onPressed()? 
*/

