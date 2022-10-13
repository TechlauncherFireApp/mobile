import 'package:flutter/material.dart';
import 'profile_logic.dart'; 

//FUTURE BUILDER
class AccountDetailsPage extends StatefulWidget {
  const AccountDetailsPage({super.key});

  @override
  State<AccountDetailsPage> createState() => _AccountDetailsPageState();
}

class _AccountDetailsPageState extends State<AccountDetailsPage> {
  late Future<List<String>> _profileResult; 

  @override
  void initState() {
    super.initState();
    _profileResult = profileRequest(getID(), ['email', 'mobile_number', 'gender']);
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
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            return AccountForm(autofill: snapshot.data);
          }
          return Container();
        },
      ),
   );
  }
}

//FORM ITSELF
class AccountForm extends StatefulWidget {
  final autofill;
  const AccountForm({
    super.key,
    this.autofill,
  });

  @override
  State<AccountForm> createState() => _AccountForm();
}

class _AccountForm extends State<AccountForm> {
  //FORM SETUP
  final _formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  late String phoneResetValue;
  TextEditingController emailController = TextEditingController();
  bool changeChecked = false;

  @override
  void initState() {
    super.initState();
    phoneController.text = widget.autofill[1];
    phoneResetValue = widget.autofill[1];[1];
    emailController.text = widget.autofill[1];[0];
  }

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
    emailController.dispose(); 
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
            buildEmailField(),
            buildPhoneField(),
            Visibility(
                visible: changeChecked, child: buildUpdateButton(context)),
            //Visbility widget allows the hidden status of fields to be toggled - auto handles turning off valudation
          ],
        ),
      ),
    );
  }

  Widget buildPhoneField() {
    return TextFormField(
      controller: phoneController,
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
            await profileUpdate(getID(), 'phone', phoneController.text); 
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
