import 'package:flutter/material.dart';

class DietaryPage extends StatefulWidget {
  const DietaryPage({super.key});

  @override
  State<DietaryPage> createState() => _DietaryPageState();
}

class _DietaryPageState extends State<DietaryPage> {
  String tempAllergy =
      "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
  String tempDiet =
      "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";

  @override
  void initState() {
    // _eventData = request; // API Request - API to download dietary and allergy info

    //TEMP TO SHOW EXANPLE WORKS
    dietController.text = tempDiet;
    allergyController.text = tempAllergy;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Dietary Requirements'),
        ),
        resizeToAvoidBottomInset: false,
        body: dietaryForm()
        /*
      FutureBuilder(
        future: _eventData , //Data from API Request
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            // return dietaryForm(snapshot.data);
            return dietaryForm();
          }
          return Container();
        },
      ),*/
        );
  }

  //FORM SETUP
  final _formKey = GlobalKey<FormState>();
  TextEditingController dietController = TextEditingController();
  TextEditingController allergyController = TextEditingController();
  bool changeChecked = false;

  //Allergy  TextField
  Widget dietaryForm() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildDietaryField(),
            buildAllergyField(),
            Visibility(
                visible: changeChecked, child: buildUpdateButton(context)),
            //Visbility widget allows the hidden status of fields to be toggled - auto handles turning off valudation
            //Visibility(visible: !allDayChecked, child: buildStartTimeField()),
          ],
        ),
      ),
    );
  }

  //Dietary TextField
  Widget buildDietaryField() {
    return TextFormField(
      controller: dietController,
      decoration: const InputDecoration(
        icon: Icon(Icons.fastfood),
        hintText: 'Enter the event Title',
        labelText: 'Dietary Preferences',
      ),
      keyboardType: TextInputType.multiline,
      minLines: 1, //Normal textInputField will be displayed
      maxLines: 7, // when user presses enter it will adapt to it
      onChanged: (text) {
        setState(() {
          if (text != tempAllergy) {
            // If text changed from the saved parameters then update button will show!
            changeChecked = true;
          }
        });
      },
    );
  }

  //Title Text Field
  Widget buildAllergyField() {
    return TextFormField(
      controller: allergyController,
      decoration: const InputDecoration(
        icon: Icon(Icons.vaccines),
        hintText: 'Enter the event Title',
        labelText: 'Allergies',
      ),
      keyboardType: TextInputType.multiline,
      minLines: 1, //Normal textInputField will be displayed
      maxLines: 7, // when user presses enter it will adapt to it
      onChanged: (text) {
        setState(() {
          if (text != tempAllergy) {
            // If text changed from the saved parameters then update button will show!
            changeChecked = true;
          }
        });
      },
    );
  }

  // Submit Button
  Widget buildUpdateButton(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(top: 40.0),
        // ignore: unnecessary_new
        child: ElevatedButton(
          child: const Text('Update'),
          // SUBMIT FUNCTION
          onPressed: () async {
            setState(() {
              changeChecked = false;
            });
            print("gotcha");

            // Call update api
          },
        ),
      ),
    );
  }
}
