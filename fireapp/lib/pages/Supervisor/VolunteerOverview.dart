import 'package:flutter/material.dart';
import '../settings/profile_logic.dart'; 

//FUTURE BUILDER
class OverviewPage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final passedID; 
  const OverviewPage({super.key, this.passedID});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  late Future<List<String>> _profileResult; 

  @override
  void initState() {
    super.initState();
    _profileResult = profileRequest(widget.passedID, ['first name', 'last name', 'email', 'mobile_number', 'dietary', 'allergy']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Dietary Requirements'),
        ),
        resizeToAvoidBottomInset: false,
        body: FutureBuilder(
        future: _profileResult , //Data from API Request
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return buildOverviewPage(snapshot.data);
          }
          return Container();
        },
      ),
   );
  }

  Widget buildOverviewPage(List<String> autofill){
    String name = autofill[0] + " " + autofill[1];
    String email = autofill[2]; 
    String phone = autofill[3]; 
    String diet = autofill[4];
    String allergy = autofill[5];

    return Center(
      child: Column(
        children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: CircleAvatar(
                backgroundColor: Colors.amber,
                child: Text(name[0]),  //First letter from first name
                radius: 80,
              ),
            ),
            Column(
              children: [
                placeholderButton(context, 'Contact'),
                placeholderButton(context, 'Training')
              ]
            ),
            Text("Name: $name"),
            Text("Email: $email"),
            Text("Phone: $phone"),
            Text("Dietary Requirements:"),
            Text(diet),
            Text("Allergies"),
            Text(allergy)
        ],
      ),
    ); 
  }

  Widget placeholderButton(BuildContext context, String buttontext) {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(top: 20.0),
        // ignore: unnecessary_new
        child: ElevatedButton(
          child: Text(buttontext),
          // SUBMIT FUNCTION
          onPressed: ()  {
          },
        ),
      ),
    );
  }
}



