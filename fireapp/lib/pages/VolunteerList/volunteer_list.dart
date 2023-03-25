import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VolunteerList extends StatelessWidget {
  const VolunteerList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: const Text('Volunteer List'),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding:const EdgeInsets.all(8.0),
              child: Text(
                'Volunteer List',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ),
            ])
          ),
    );

    
  }
}