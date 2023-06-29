
import 'dart:async';

import 'package:fireapp/base/spaced_by.dart';
import 'package:fireapp/base/widget.dart';
import 'package:fireapp/domain/request_state.dart';
import 'package:fireapp/presentation/fireapp_page.dart';
import 'package:fireapp/presentation/login/login_navigation.dart';
import 'package:fireapp/presentation/login/login_view_model.dart';
import 'package:fireapp/style/theme.dart';
import 'package:fireapp/widgets/fill_width.dart';
import 'package:fireapp/widgets/form/password_form_field.dart';
import 'package:fireapp/widgets/request_state_spinner.dart';
import 'package:fireapp/widgets/request_state_widget.dart';
import 'package:fireapp/widgets/scroll_view_bottom_content.dart';
import 'package:fireapp/widgets/standard_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../widgets/simple_divider.dart';

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
    return Scaffold(
      body: SafeArea(
        child: ScrollViewBottomContent(
          padding: EdgeInsets.all(1.rdp()),
          bottomChildren: [
            SizedBox(height: 1.rdp(),),
            FillWidth(
              child: StandardButton(
                type: ButtonType.primary,
                onPressed: () => viewModel.login(),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context)?.loginContinue ?? ""),
                    RequestStateSpinner.stream(
                      state: viewModel.state,
                      child: SizedBox(
                        width: 1.rdp(),
                        height: 1.rdp(),
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      )
                    )
                  ].spacedBy(0.5.rdp()),
                )
              )
            ),
            FillWidth(
              child: StandardButton(
                type: ButtonType.tertiary,
                onPressed: () => viewModel.navigateToRegister(),
                child: Text(AppLocalizations.of(context)?.loginToRegister ?? "")
              )
            ),
          ],
          children: [
            Text("Logo goes here"),
            buildLogin(context)
          ],
        ),
      ),
    );
  }

  Widget buildLogin(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          FillWidth(
            child: Text(
              AppLocalizations.of(context)?.loginBlurb ?? "",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          SizedBox(height: 0.5.rdp(),),
          TextFormField(
            decoration: textFieldStyle(
              context,
              radius: BorderRadius.only(
                topLeft: Radius.circular(0.5.rdp()),
                topRight: Radius.circular(0.5.rdp())
              )
            ).copyWith(
              hintText: AppLocalizations.of(context)?.registerUsername ?? "",
            ),
            controller: viewModel.email,
            validator: (v) {
              if (v!.isEmpty) {
                return 'Email is empty!';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 2,
          ),
          PasswordFormField(
            decoration: textFieldStyle(
              context,
              radius: BorderRadius.only(
                bottomLeft: Radius.circular(0.5.rdp()),
                bottomRight: Radius.circular(0.5.rdp())
              )
            ).copyWith(
              hintText: AppLocalizations.of(context)?.loginPassword ?? ""
            ),
            controller: viewModel.password,
            validator: (v) {
              if (v!.isEmpty) {
                return 'Password is empty!';
              }
              return null;
            },

          ),
          buildForgotPasswordText(context),
          StreamBuilder(
            stream: viewModel.state,
            builder: (_, d) {
              if (!d.hasData) return Container();
              final data = d.data;
              if (data == null || data is! ExceptionRequestState) return Container();
              return Text(
                "${data.exception}",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget buildForgotPasswordText(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: StandardButton(
        type: ButtonType.tertiary,
        onPressed: () => viewModel.navigateToForgotPassword(),
        child: Text(
          AppLocalizations.of(context)?.loginForgotPassword ?? "",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).hintColor
          )
        )
      )
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