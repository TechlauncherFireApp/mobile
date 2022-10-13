import 'package:flutter/material.dart';
import 'profile_logic.dart'; 

//FUTURE BUILDER
class DietaryPage extends StatefulWidget {
  const DietaryPage({super.key});

  @override
  State<DietaryPage> createState() => _DietaryPageState();
}

class _DietaryPageState extends State<DietaryPage> {
  late Future<List<String>> _profileResult; 

  @override
  void initState() {
    super.initState();
    _profileResult = profileRequest(getID(), ['dietary', 'allergy']);
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
            print('1');
            return DietaryForm(autofill: snapshot.data);
          }
          return Container();
        },
      ),
   );
  }
}

//FORM ITSELF
class DietaryForm extends StatefulWidget {
  final autofill;
  const DietaryForm({
    super.key,
    this.autofill,
  });

  @override
  State<DietaryForm> createState() => _DietaryForm();
}

class _DietaryForm extends State<DietaryForm> {
  //FORM SETUP
  final _formKey = GlobalKey<FormState>();
  late String DietResetCheck; 
  TextEditingController dietController = TextEditingController();
  late String AllergyResetCheck;
  TextEditingController allergyController = TextEditingController();
  bool changeChecked = false;

  @override
  void initState() {
    super.initState();
    allergyController.text = widget.autofill[1];
    AllergyResetCheck = widget.autofill[1];
    dietController.text = widget.autofill[0];
    DietResetCheck = widget.autofill[0];
  }

  @override
  void dispose() {
    super.dispose();
    dietController.dispose();
    allergyController.dispose(); 
  }

  @override
  Widget build(BuildContext context) {
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
          if (text != DietResetCheck) {
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
          if (text != AllergyResetCheck) {
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
            if (allergyController.text != AllergyResetCheck){
              await profileUpdate(getID(), 'allergy', allergyController.text); 
            }
            if (dietController.text != DietResetCheck){
              await profileUpdate(getID(), 'dietary', dietController.text); 
            }
            setState(() {
              changeChecked = false;
            });
            // Call update api
          },
        ),
      ),
    );
  }
}


// LOGIC //


