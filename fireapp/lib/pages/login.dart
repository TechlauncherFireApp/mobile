import 'package:flutter/material.dart';
import '../constants.dart' as constants;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fireapp/layout/dialog.dart';
import 'package:fireapp/layout/loading.dart';

/// The login page container
class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Material is a conceptual piece
    // of paper on which the UI appears.
    return Column(
      children: const [
        Expanded(child: LoginBox()),
        RegisterText(),
      ],
    );
  }
}

/// Login box
///
/// contains username text field, password text field,
/// forgot password and sign in button
///
/// Hint: You can try to imitate the way to develop your own page
class LoginBox extends StatefulWidget {
  const LoginBox({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginBoxState();
}

/// State Object of Login Box
///
/// Specific implementation of login box
///
/// In this class I choose to put the implementation of
/// different component functions in different methods
/// which makes the structure clearer,
/// and the method name represents the purpose of the component
class _LoginBoxState extends State<LoginBox> {
  final GlobalKey _formKey = GlobalKey<FormState>(); // Used to submit inputs
  late String _user, _password;
  bool _isObscure = true; // Password is obscure or not
  final clearPassword = TextEditingController();
  int loginCount = 0;

  @override
  void initState() {
    super.initState();
    _user = "";
    _password = "";
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 20), // Blank lines of a certain height
          buildTitle(), // Login
          const SizedBox(height: 20),
          buildUserTextField(),
          const SizedBox(height: 30),
          buildPasswordTextField(), // Password text field
          buildForgotPasswordText(context), // Forgot password button
          const SizedBox(height: 30),
          buildLoginButton(context),
        ],
      ),
    );
  }

  Widget buildTitle() {
    return const Padding(
        padding: EdgeInsets.all(8),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ));
  }

  Widget buildUserTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Username or Email'),
      validator: (v) {
        if (v!.isEmpty) {
          return 'Username is empty!';
        }
        return null;
      },
      onSaved: (v) => _user = v!,
    );
  }

  Widget buildPasswordTextField() {
    return TextFormField(
      obscureText: _isObscure,
      validator: (v) {
        if (v!.isEmpty) {
          return 'Password is empty!';
        }
        return null;
      },
      onSaved: (v) => _password = v!,
      decoration: InputDecoration(
        labelText: 'Password',
        suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            },
            icon: _isObscure
                ? const Icon(Icons.remove_red_eye_outlined)
                : const Icon(Icons.remove_red_eye),
            splashRadius: 20),
      ),
      controller: clearPassword,
    );
  }

  Widget buildForgotPasswordText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () {
            //TODO Forgot password page
          },
          child: const Text("Forgot Password?",
              style: TextStyle(fontSize: 14, color: Colors.grey)),
        ),
      ),
    );
  }

  Widget buildLoginButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45,
        width: 270,
        child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(const StadiumBorder(
                  side: BorderSide(style: BorderStyle.none)))),
          child: Text('Sign In',
              style: Theme.of(context).primaryTextTheme.headline6),
          onPressed: () {
            if ((_formKey.currentState as FormState).validate()) {
              (_formKey.currentState as FormState).save();
              // Display loading dialog
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return NetLoadingDialog(
                        loadingMethod: login(), operation: loginOperation);
                  });
            }
          },
        ),
      ),
    );
  }

  /// Http post request to ask for login
  Future<LoginResult> login() async {
    loginCount++;
    var url = Uri.https(constants.domain, 'authentication/login');
    try {
      var response = await http.post(url,
          body: json.encode({"email": _user, "password": _password}));
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

  /// Operation after login
  loginOperation(var result) {
    showToast(result);
    // Clear password text field and value after login
    clearPassword.clear();
    _password = "";
    if (result == LoginResult.success) {
      Navigator.pushNamed(context, '/nav');
    }
  }
}

/// The bottom register module
class RegisterText extends StatelessWidget {
  const RegisterText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: <Widget>[
          const Text('----------New to FireApp?----------',
              style: TextStyle(fontSize: 16, color: Colors.black45)),
          const SizedBox(height: 16),
          MaterialButton(
            color: Colors.grey,
            child:
                const Text('Create an account', style: TextStyle(fontSize: 16)),
            onPressed: () {
              // TODO Register page
            },
          )
        ],
      ),
    );
  }
}

enum LoginResult { success, fail, networkError, timeout }
