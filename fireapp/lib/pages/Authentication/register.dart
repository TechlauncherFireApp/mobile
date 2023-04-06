import 'package:fireapp/data/persistence/authentication_persistence.dart';
import 'package:flutter/material.dart';
import 'package:fireapp/global/constants.dart' as constants; //API URL
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fireapp/layout/dialog.dart';
import 'package:fireapp/layout/loading.dart';

/// The login page container
class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Material is a conceptual piece
    // of paper on which the UI appears.
    return Column(
      children: const [
        Expanded(child: RegisterBox()),
        // RegisterText(),
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
class RegisterBox extends StatefulWidget {
  const RegisterBox({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterBoxState();
}

/// State Object of Login Box
///
/// Specific implementation of login box
///
/// In this class I choose to put the implementation of
/// different component functions in different methods
/// which makes the structure clearer,
/// and the method name represents the purpose of the component
class _RegisterBoxState extends State<RegisterBox> {
  // This violates the whole layered thing, but I don't want to rewrite the compat
  final AuthenticationPersistence _authenticationPersistence =
      GetIt.instance.get();

  final GlobalKey _formKey = GlobalKey<FormState>(); // Used to submit inputs
  late String _user, _password, _givenName, _lastName, _phone;
  bool _isObscure = true; // Password is obscure or not

  // var _genderValue = "";
  // var _dietaryValue = "";
  var _genderValue = null;
  var _dietaryValue = null;

  List<DropdownMenuItem> getGenderList() {
    List<DropdownMenuItem> genderList = [];
    genderList.add(DropdownMenuItem(child: Text(""), value: ""));
    genderList.add(DropdownMenuItem(child: Text("Male"), value: "MALE"));
    genderList.add(DropdownMenuItem(child: Text("Female"), value: "FEMALE"));
    return genderList;
  }

  List<DropdownMenuItem> getDietaryList() {
    List<DropdownMenuItem> dietaryList = [];
    dietaryList.add(DropdownMenuItem(child: Text(""), value: ""));
    dietaryList.add(DropdownMenuItem(child: Text("meals"), value: "meals"));
    dietaryList
        .add(DropdownMenuItem(child: Text("vegetarian"), value: "vegetarian"));
    return dietaryList;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 20), // Blank lines of a certain height
          email(), // Login
          const SizedBox(height: 20),
          buildUserTextField(),
          const SizedBox(height: 20),
          password(),
          const SizedBox(height: 20),
          buildPasswordTextField(), // Password text field
          const SizedBox(height: 20),
          givenName(),
          const SizedBox(height: 20),
          buildGivenNameTextField(),
          const SizedBox(height: 20),
          lastName(),
          const SizedBox(height: 20),
          buildLastNameTextField(),
          const SizedBox(height: 20),
          phoneNumber(),
          const SizedBox(height: 20),
          buildPhoneTextField(),
          const SizedBox(height: 20),
          gender(),
          const SizedBox(height: 20),
          genderDropDownList(context),
          const SizedBox(height: 20),
          dietary(),
          const SizedBox(height: 20),
          dietaryDropDownList(context),

          const SizedBox(height: 30),
          buildRegisterButton(context),
        ],
      ),
    );
  }

  Widget email() {
    return const Padding(
        padding: EdgeInsets.all(8),
        child: Text(
          'Email*',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ));
  }

  Widget password() {
    return const Padding(
        padding: EdgeInsets.all(8),
        child: Text(
          'Password*',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ));
  }

  Widget givenName() {
    return const Padding(
        padding: EdgeInsets.all(8),
        child: Text(
          'Given Name*',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ));
  }

  Widget lastName() {
    return const Padding(
        padding: EdgeInsets.all(8),
        child: Text(
          'Last Name*',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ));
  }

  Widget phoneNumber() {
    return const Padding(
        padding: EdgeInsets.all(8),
        child: Text(
          'Phone Number*',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ));
  }

  Widget gender() {
    return const Padding(
        padding: EdgeInsets.all(8),
        child: Text(
          'Gender',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ));
  }

  Widget dietary() {
    return const Padding(
        padding: EdgeInsets.all(8),
        child: Text(
          'Dietary',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ));
  }

  Widget buildUserTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Please enter your email'),
      validator: (v) {
        if (v!.isEmpty) {
          return 'e-mail is empty!';
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
        ));
  }

  Widget buildGivenNameTextField() {
    return TextFormField(
      decoration:
          const InputDecoration(labelText: 'Please enter your given name'),
      validator: (v) {
        if (v!.isEmpty) {
          return 'given is empty!';
        }
        return null;
      },
      onSaved: (v) => _givenName = v!,
    );
  }

  Widget buildLastNameTextField() {
    return TextFormField(
      decoration:
          const InputDecoration(labelText: 'Please enter your last name'),
      validator: (v) {
        if (v!.isEmpty) {
          return 'Last name is empty!';
        }
        return null;
      },
      onSaved: (v) => _lastName = v!,
    );
  }

  Widget buildPhoneTextField() {
    return TextFormField(
      decoration:
          const InputDecoration(labelText: 'Please enter your phone number'),
      validator: (v) {
        if (v!.isEmpty) {
          return 'Phone number is empty!';
        }
        return null;
      },
      onSaved: (v) => _phone = v!,
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

  Widget buildRegisterButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45,
        width: 270,
        child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(const StadiumBorder(
                  side: BorderSide(style: BorderStyle.none)))),
          child: Text('Sign Up',
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
                        loadingMethod: register(), operation: showToast);
                  });
            }
          },
        ),
      ),
    );
  }

  Widget genderDropDownList(BuildContext context) {
    return DropdownButton<dynamic>(
      hint: Text("Select your gender"),
      items: getGenderList(),
      onChanged: (value) {
        setState(() {
          _genderValue = value;
        });
      },
      isExpanded: true,
      value: _genderValue,
      iconSize: 48,
      style: TextStyle(color: Colors.green),
    );
  }

  Widget dietaryDropDownList(BuildContext context) {
    return DropdownButton<dynamic>(
      hint: Text("Select your dietary"),
      items: getDietaryList(),
      onChanged: (value) {
        setState(() {
          _dietaryValue = value;
        });
      },
      isExpanded: true,
      value: _dietaryValue,
      iconSize: 48,
      style: TextStyle(color: Colors.green),
    );
  }

  /// Http post request to ask for login

  Future<String> register() async {
    var url = Uri.https(constants.domain, 'authentication/register');
    try {
      var response;
      if (_genderValue == null && _dietaryValue == null) {
        response = await http.post(url,
            body: json.encode({
              "email": _user,
              "password": _password,
              "given_name": _givenName,
              "last_name": _lastName,
              "phone": _phone
            }));
      } else if (_genderValue == null) {
        response = await http.post(url,
            body: json.encode({
              "email": _user,
              "password": _password,
              "given_name": _givenName,
              "last_name": _lastName,
              "phone": _phone,
              "gender": _genderValue
            }));
      } else if (_dietaryValue == null) {
        response = await http.post(url,
            body: json.encode({
              "email": _user,
              "password": _password,
              "given_name": _givenName,
              "last_name": _lastName,
              "phone": _phone,
              "diet": _dietaryValue
            }));
      } else {
        response = await http.post(url,
            body: json.encode({
              "email": _user,
              "password": _password,
              "given_name": _givenName,
              "last_name": _lastName,
              "phone": _phone,
              "gender": _genderValue,
              "diet": _dietaryValue
            }));
      }

      if (response.statusCode == 200) {
        var loginBean = json.decode(response.body);
        if (loginBean['result'] == "SUCCESS") {
          return "SUCCESS";
        } else if (loginBean['result'] == "USERNAME_ALREADY_REGISTERED") {
          return "USERNAME ALREADY REGISTERED";
        } else if (loginBean['result'] == "BAD_USERNAME") {
          return "BAD USERNAME";
        } else if (loginBean['result'] == "BAD_PASSWORD") {
          return "PASSWORD DOESN'T MEET REQUIREMENT";
        } else {
          return "BAD ROLE";
        }
      } else {
        return "NETWORK ERROR";
      }
    } catch (_) {
      return "TIME OUT";
    }
  }
}

/// The bottom register module
// class RegisterText extends StatelessWidget {
//   const RegisterText({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 16),
//       child: Column(
//         children: <Widget>[
//           const Text('----------New to FireApp?----------',
//               style: TextStyle(fontSize: 16, color: Colors.black45)),
//           const SizedBox(height: 16),
//           MaterialButton(
//             color: Colors.grey,
//             child:
//             const Text('Create an account', style: TextStyle(fontSize: 16)),
//             onPressed: () {
//               // TODO Register page
//             },
//           )
//         ],
//       ),
//     );
//   }
// }
//
// enum LoginResult {
//   success,
//   fail,
//   networkError,
//   timeout
// }

enum RegisterResult {
  SUCCESS,
  USERNAME_ALREADY_REGISTERED,
  BAD_USERNAME,
  BAD_PASSWORD,
  BAD_ROLE,
  networkError,
  timeout
}
