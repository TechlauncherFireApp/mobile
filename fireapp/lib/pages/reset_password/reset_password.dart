import 'package:flutter/material.dart';
import '../login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants.dart' as constants;

class ResetPasswordPage extends StatelessWidget {
  final String email;
  ResetPasswordPage({Key? key, required this.email}) :super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: ResetPasswordBox(email: email,)),
      ],
    );
  }
}
class ResetPasswordBox extends StatefulWidget {
  final String email;
  ResetPasswordBox({Key? key,required this.email}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ResetPasswordBoxState();
}

class _ResetPasswordBoxState extends State<ResetPasswordBox> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  String _password = "", _passwordT = "";
  final myController = TextEditingController();
  final myControllerTwo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final GlobalKey _formKey = GlobalKey<FormState>(); // Used to submit inputs
    return Scaffold(
        // appBar: new AppBar(title: Text('Reset Password'),),
        body: Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 20), // Blank lines of a certain height
          buildTitle(), // Reset Password
          const SizedBox(height: 20),
          buildPasswordTextField(),
          const SizedBox(height: 20),
          buildRepeatPasswordTextField(),
          const SizedBox(height: 30),
          buildSubmitButton(context),
        ],
      ),
    )
      );
  }

  /// Http post request to ask for login
  Future<LoginResult> Reset() async {
    var url = Uri.https(constants.domain, 'authentication/reset');
    try {
      var response = await http.post(url,
          body: json.encode({"email": widget.email,"new_password":myController.text,"repeat_password":myControllerTwo.text}));
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

  Widget buildTitle() {
    return const Padding(
        padding: EdgeInsets.all(8),
        child: Text(
          'Reset your password',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ));
  }

  Widget buildPasswordTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'New Password'),
      validator: (v) {
        if (v!.isEmpty) {
          return 'New Password is empty!';
        }
      },
      controller: myController,
      onSaved: (v) => {
        _password = v!
      },
    );
  }

  Widget buildRepeatPasswordTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'New Password Again'),
      validator: (v) {
        if (v!.isEmpty) {
          return 'Repeat Password is empty!';
        }
      },
      controller: myControllerTwo,
      onSaved: (v) => {
        _passwordT = v!
      },
    );
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
            Reset().then((value) => {
              if(value == LoginResult.success){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),)
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