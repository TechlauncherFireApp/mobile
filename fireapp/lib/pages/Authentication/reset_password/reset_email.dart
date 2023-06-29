import 'package:fireapp/base/spaced_by.dart';
import 'package:fireapp/style/theme.dart';
import 'package:fireapp/widgets/fill_width.dart';
import 'package:fireapp/widgets/fireapp_app_bar.dart';
import 'package:fireapp/widgets/standard_button.dart';
import 'package:flutter/material.dart';
import 'package:fireapp/global/constants.dart' as constants; //API URL
import 'package:fireapp/pages/Authentication/login.dart';
import 'reset_with_code.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResetPage extends StatelessWidget {
  const ResetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Expanded(child: ResetBox()),
      ],
    );
  }
}

class ResetBox extends StatefulWidget {
  const ResetBox({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ResetBoxState();
}

class _ResetBoxState extends State<ResetBox> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  String _email = "";
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final GlobalKey _formKey = GlobalKey<FormState>(); // Used to submit inputs
    return Scaffold(
      appBar: fireAppAppBar(context, 'Reset Password'),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [// Blank lines of a certain height
            SizedBox(height: 0.5.rdp(),),
            const Text(
              'Please input your email',
            ), // Reset Passwo
            buildEmailTextField(),
            buildSubmitButton(context),
          ].spacedBy(1.rdp()),
        ),
      )
    );
  }

  Widget buildEmailTextField() {
    return TextFormField(
      decoration: textFieldStyle(context).copyWith(
          labelText: 'Email Address'
      ),
      validator: (v) {
        if (v!.isEmpty) {
          return 'Email account is empty!';
        }
        var emailReg = RegExp(
            r"[\w!#$%&'*+/=?^_`{|}~-]+(?:\.[\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\w](?:[\w-]*[\w])?\.)+[\w](?:[\w-]*[\w])?");
        if (!emailReg.hasMatch(v)) {
          return 'Invalid email';
        }
      },
      controller: myController,
      onSaved: (v) => {_email = v!},
    );
  }

  /// Http post request to ask for login
  Future<LoginResult> sendCode() async {
    var url = Uri.https(constants.domain, 'authentication/send_code');
    try {
      var response =
          await http.post(url, body: json.encode({"email": myController.text}));
      if (response.statusCode == 200) {
        var loginBean = json.decode(response.body);
        if (loginBean['result'] == "SUCCESS") {
          return LoginResult.success;
        } else {
          return LoginResult.fail;
        }
      } else {
        return LoginResult.networkError;
      }
    } catch (_) {
      return LoginResult.timeout;
    }
  }

  Widget buildSubmitButton(BuildContext context) {
    return FillWidth(
      child: StandardButton(
        // This is crap
        onPressed: (){
          sendCode().then((value) => {
            if (value == LoginResult.success)
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ResetCodePage(email: myController.text)),
                )
              }
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => ResetCodePage()),)
          });
        },
        child: Text("Submit"),
      ),
    );
  }
}
