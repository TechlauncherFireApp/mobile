import 'package:flutter/material.dart';
import 'reset_with_code.dart';

class ResetPage extends StatelessWidget {
  const ResetPage({Key? key}) :super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
  late String _email;

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
          buildEmailTextField(),
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
          'Reset Password',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ));
  }

  Widget buildEmailTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Email Address'),
      validator: (v) {
        var emailReg = RegExp(
            r"[\w!#$%&'*+/=?^_`{|}~-]+(?:\.[\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\w](?:[\w-]*[\w])?\.)+[\w](?:[\w-]*[\w])?");
        if (!emailReg.hasMatch(v!)) {
          return 'please input correct email account';
        }
      },
      onSaved: (v) => _email = v!,
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
              MaterialPageRoute(builder: (context) => ResetCodePage()),
            );
          },
        ),
      ),
    );
  }
}
