import 'package:flutter/material.dart';

class VolunteerHome extends StatelessWidget {
  const VolunteerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          buildClock(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(Icons.qr_code_2, size: 33),
        onPressed: () {},
      ),
    );
  }

  Widget buildClock() {
    return Center(
      child: Card(
        child: Column(
          children: [
            //Big Ol Clock,
            //underline?,
            Text(
                "No assigned shifts at this stage"), //If there is a shift; then change to "Start" and "Stop" buttons in green/red boxes
          ],
        ),
      ),
    );
  }
}
