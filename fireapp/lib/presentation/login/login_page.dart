
import 'dart:async';

import 'package:fireapp/base/spaced_by.dart';
import 'package:fireapp/base/widget.dart';
import 'package:fireapp/domain/request_state.dart';
import 'package:fireapp/presentation/fireapp_page.dart';
import 'package:fireapp/presentation/login/login_navigation.dart';
import 'package:fireapp/presentation/login/login_view_model.dart';
import 'package:fireapp/widgets/form/password_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State createState() => _LoginState();
}

class _LoginState
    extends FireAppState<LoginPage>
    with Navigable<LoginNavigation, LoginPage>
    implements ViewModelHolder<LoginViewModel>
{

  @override
  LoginViewModel viewModel = GetIt.instance.get<LoginViewModel>();
  final GlobalKey _formKey = GlobalKey<FormState>(); // Used to submit inputs

  @override
  void handleNavigationEvent(LoginNavigation event) {
    if (event is HomeLoginNavigation) {
      Navigator.of(context).popAndPushNamed("/nav");
      return;
    }

    if (event is RegisterLoginNavigation) {
      Navigator.of(context).popAndPushNamed("/register");
      return;
    }

    if (event is ForgotPasswordLoginNavigation) {
      Navigator.of(context).pushNamed("/reset_password");
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: buildLogin()),
        buildRegisterText(),
      ],
    );
  }

  Widget buildRegisterText() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          const Text('----------New to FireApp?----------',
              style: TextStyle(fontSize: 16, color: Colors.black45)),
          const SizedBox(height: 16),
          MaterialButton(
            minWidth: double.infinity,
            color: Colors.grey,
            child:
            const Text('Create an account', style: TextStyle(fontSize: 16)),
            onPressed: () {
              Navigator.pushNamed(context, '/register');
            },
          )
        ],
      ),
    );
  }

  Widget buildLogin() {
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
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ));
  }

  Widget buildUserTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Username or Email'),
      controller: viewModel.email,
      validator: (v) {
        if (v!.isEmpty) {
          return 'Username is empty!';
        }
        return null;
      },
    );
  }

  Widget buildPasswordTextField() {
    return PasswordFormField(
      password: viewModel.password,
      label: AppLocalizations.of(context)?.loginPassword ?? "",
      validator: (v) {
        if (v!.isEmpty) {
          return AppLocalizations.of(context)?.formFieldEmpty(
            AppLocalizations.of(context)?.loginPassword ?? ""
          );
        }
        return null;
      },
    );
  }

  Widget buildForgotPasswordText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () {
            viewModel.navigateToForgotPassword();
          },
          child: const Text("Forgot Password?",
              style: TextStyle(fontSize: 14, color: Colors.grey)),
        ),
      ),
    );
  }

  Widget buildLoginButton(BuildContext context) {
    return StreamBuilder<RequestState<void>>(
      stream: viewModel.state,
      builder: (context, value) {
        if (!value.hasData) return Container();
        var data = value.data;
        var onPressed = (data is! LoadingRequestState) ? () {
          if ((_formKey.currentState as FormState).validate()) {
            viewModel.login();
          }
        } : null;
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(40), // fromHeight use double.infinity as width and 40 is the height
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  'Sign In',
                  style: Theme.of(context).primaryTextTheme.headline6
              ),
              if (data is LoadingRequestState) SizedBox(
                height: 8,
                width: 8,
                child: CircularProgressIndicator(
                    color: (Theme.of(context).primaryTextTheme.headline6?.color ?? Colors.white)
                ),
              )
            ].spacedBy(8),
          )
        );
      },
    );
  }

}