import 'package:flutter/material.dart';
import 'profile_logic.dart'; 

class AccountDetailsPage extends StatefulWidget {
  const AccountDetailsPage({super.key});

  @override
  State<AccountDetailsPage> createState() => _AccountDetailsPageState();
}

class _AccountDetailsPageState extends State<AccountDetailsPage> {

  late Future<List<String>> _profileResult; 

  @override
  void initState() {
    // _eventData = request; // API Request - API to download dietary and allergy info

    //TEMP TO SHOW EXANPLE WORKS
    _profileResult = profileRequest(getID(), ['email', 'mobile_number', 'gender']);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Account Details'),
        ),
        resizeToAvoidBottomInset: false,
        body: FutureBuilder(
        future: _profileResult , //Data from API Request
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return accountForm(snapshot.data);
          }
          return Container();
        },
      ),
   );
  }

  //FORM SETUP
  final _formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  late String phoneResetValue;
  TextEditingController emailController = TextEditingController();
  bool changeChecked = false;

  //
  Widget accountForm(List<String> autofill) {
    phoneResetValue = autofill[1];
    emailController.text = autofill[0];

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildEmailField(),
            buildPhoneField(autofill[1]),
            Visibility(
                visible: changeChecked, child: buildUpdateButton(context)),
            //Visbility widget allows the hidden status of fields to be toggled - auto handles turning off valudation
          ],
        ),
      ),
    );
  }

  Widget buildPhoneField(String defaultValue) {
    return TextFormField(
      initialValue: defaultValue,
      decoration: const InputDecoration(
        icon: Icon(Icons.phone),
        hintText: 'Phone Number',
        labelText: 'Phone Number',
      ),
      keyboardType: TextInputType.multiline,
      minLines: 1, //Normal textInputField will be displayed
      onChanged: (text) {
        setState(() {
          if (text != phoneResetValue) {
            // If text changed from the saved parameters then update button will show!
            changeChecked = true;
          }
        });
      },
    );
  }

  Widget buildEmailField() {
    return TextFormField(
      controller: emailController,
      decoration: const InputDecoration(
        icon: Icon(Icons.email),
        labelText: 'Email',
      ),
      minLines: 1, //Normal textInputField will be displayed
      readOnly: true, //Linked to login details - for now not changeable 
    );
  }

  //Gender as a dropdown?

  //Email as a textfield or is it fixed because its primary thing linked to acccount?

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
