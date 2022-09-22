import 'package:flutter/material.dart';
import '../../constants.dart' as constants;
import '../login.dart';
import 'reset_with_code.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResetPage extends StatelessWidget {
  const ResetPage({Key? key}) :super(key: key);

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
        // appBar: AppBar(title: Text('Reset Password'),),
        body: Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 20), // Blank lines of a certain height
          buildTitle(), // Reset Password
          const SizedBox(height: 20),
          buildEmailTextField(),
          const SizedBox(height: 30),
          buildSubmitButton(context),
        ],
      ),
    ));
  }

  Widget buildTitle() {
    return const Padding(
        padding: EdgeInsets.all(8),
        child: Text(
          'Input your email account',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ));
  }

  Widget buildEmailTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Email Address'),
      validator: (v) {
        if (v!.isEmpty) {
          return 'Email account is empty!';
        }
        var emailReg = RegExp(
            r"[\w!#$%&'*+/=?^_`{|}~-]+(?:\.[\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\w](?:[\w-]*[\w])?\.)+[\w](?:[\w-]*[\w])?");
        if (!emailReg.hasMatch(v!)) {
          return 'please input correct email account';
        }
      },
      controller: myController,
      onSaved: (v) => {
        _email = v!
      },
    );
  }
  /// Http post request to ask for login
  Future<LoginResult> sendCode() async {
    var url = Uri.https(constants.domain, 'authentication/send_code');
    try {
      var response = await http.post(url,
          body: json.encode({"email": myController.text}));
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
    return Align(
      child: SizedBox(
        height: 45,
        width: 270,
        child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(const StadiumBorder(
                  side: BorderSide(style: BorderStyle.none)))),
          child: Text('Submit',
              style: Theme
                  .of(context)
                  .primaryTextTheme
                  .headline6),
          onPressed: ()  {
            sendCode().then((value) => {
              if(value == LoginResult.success){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ResetCodePage(email:myController.text)),)
              }
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => ResetCodePage()),)

            });

          },
        ),
      ),
    );
  }
}
