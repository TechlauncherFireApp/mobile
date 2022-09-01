import 'package:flutter/material.dart';
import '../login.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({Key? key}) :super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: const [
        Expanded(child: ResetPasswordBox()),
      ],
    );
  }
}
class ResetPasswordBox extends StatefulWidget {
  const ResetPasswordBox({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ResetPasswordBoxState();
}

class _ResetPasswordBoxState extends State<ResetPasswordBox> {

  @override
  Widget build(BuildContext context) {
    final GlobalKey _formKey = GlobalKey<FormState>(); // Used to submit inputs
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 20), // Blank lines of a certain height
          buildTitle(), // Reset Password
          const SizedBox(height: 20),
          buildPasswordTextField(),
          const SizedBox(height: 30),
          buildSubmitButton(context),
        ],
      ),
    );
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
      decoration: const InputDecoration(labelText: 'Code'),
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
      ),
    );
  }
}