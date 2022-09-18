import 'package:flutter/material.dart';
import 'reset_password.dart';
import '../../constants.dart' as constants;
import '../login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResetCodePage extends StatelessWidget {
  final String email;
  ResetCodePage({Key ? key,required this.email}) :super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Expanded(child: ResetCodeBox(email: email,)),
      ],
    );
  }
}
class ResetCodeBox extends StatefulWidget {
  final String email;
  ResetCodeBox({Key? key,required this.email}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ResetCodeBoxState();
}

class _ResetCodeBoxState extends State<ResetCodeBox> {
  String _code = "";
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final GlobalKey _formKey = GlobalKey<FormState>(); // Used to submit inputs
    return Scaffold(
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: 20), // Blank lines of a certain height
            buildTitle(), // Reset Password
            const SizedBox(height: 20),
            buildCodeTextField(),
            const SizedBox(height: 30),
            buildSubmitButton(context),

          ],
        ),
      ),
    );
  }

  Widget buildTitle() {
    return const Padding(
        padding: EdgeInsets.all(8),
        child: Text(
          'Enter the Vertification Code',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ));
  }

  Widget buildCodeTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Code'),
      validator: (v) {
        if (v!.isEmpty) {
          return 'Code is empty!';
        }
      },
      controller: myController,
      onSaved: (v) => {
        _code = v!
      },
    );
  }
  /// Http post request to ask for login
  Future<LoginResult> verify() async {
    var url = Uri.https(constants.domain, 'authentication/verify');
    try {
      var response = await http.post(url,
          body: json.encode({"email":widget.email,"code": myController.text}));
      if (response.statusCode == 200) {
        var loginBean = json.decode(response.body);
        if (loginBean['result'] == "CODE_CORRECT") {
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
          onPressed: () {
            verify().then((value) => {
              if(value == LoginResult.success){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResetPasswordPage(email: widget.email,)),)
              }
            });
          },
        ),
      ),
    );
  }
}