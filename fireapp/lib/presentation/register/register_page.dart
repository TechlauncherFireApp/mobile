
import 'package:fireapp/base/spaced_by.dart';
import 'package:fireapp/base/widget.dart';
import 'package:fireapp/domain/models/reference/gender.dart';
import 'package:fireapp/presentation/fireapp_page.dart';
import 'package:fireapp/presentation/register/register_navigation.dart';
import 'package:fireapp/presentation/register/register_view_model.dart';
import 'package:fireapp/style/theme.dart';
import 'package:fireapp/widgets/form/form_field_lockup.dart';
import 'package:fireapp/widgets/form/password_form_field.dart';
import 'package:fireapp/widgets/scroll_view_bottom_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:email_validator/email_validator.dart';

import '../../domain/request_state.dart';
import '../../widgets/fill_width.dart';
import '../../widgets/request_state_spinner.dart';
import '../../widgets/standard_button.dart';

class RegisterPage extends StatefulWidget {

  const RegisterPage({super.key});

  @override
  State createState() => _RegisterPageState();

}

class _RegisterPageState
    extends FireAppState<RegisterPage>
    with Navigable<RegisterNavigation, RegisterPage>
    implements ViewModelHolder<RegisterViewModel>
{

  @override
  RegisterViewModel viewModel = GetIt.instance.get();
  final GlobalKey _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ScrollViewBottomContent(
          padding: EdgeInsets.all(1.rdp()),
          bottomChildren: bottomActions(context),
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Center(
                child: SvgPicture.asset(
                    "assets/logo/logo_color.svg"
                ),
              ),
            ),
            SizedBox(height: 1.rdp(),),
            FillWidth(
              child: Text(
                'ConstraintForm', // AppLocalizations.of(context)?.registerTitle ?? "",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            SizedBox(height: 0.5.rdp(),),
            Form(
              key: _formKey,
              child: _buildForm(),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> bottomActions(BuildContext context) {
    return [
      SizedBox(height: 1.rdp(),),
      FillWidth(
          child: StandardButton(
              type: ButtonType.primary,
              onPressed: () => viewModel.register(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context)?.registerContinue ?? ""),
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
          onPressed: () => viewModel.navigateToLogin(),
          child: Text(AppLocalizations.of(context)?.registerToLogin ?? "")
        )
      ),
    ];
  }

  Widget _buildForm() {
    var aL = AppLocalizations.of(context);
    return Column(
      children: [
        Column(
          children: [
            TextFormField(
              decoration: textFieldStyle(
                context,
                radius: BorderRadius.only(
                    topLeft: Radius.circular(0.5.rdp()),
                    topRight: Radius.circular(0.5.rdp())
                )
              ).copyWith(
                  labelText: aL?.registerUsername ?? ""
              ),
              style: Theme.of(context).textTheme.labelLarge,
              controller: viewModel.email,
              validator: (v) {
                if (v!.isEmpty) return aL?.formFieldEmpty(aL.registerUsername);
                if (EmailValidator.validate(v)) return aL?.formFieldNotEmail(aL.registerUsername);
                return null;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            PasswordFormField(
              decoration: textFieldStyle(
                context,
                radius: const BorderRadius.all(Radius.zero)
              ),
              controller: viewModel.password,
              validator: (v) {
                if (v!.isEmpty) return aL?.formFieldEmpty(aL.registerPassword);
                return null;
              },
              label: aL?.registerPassword ?? "",
            ),
            TextFormField(
              decoration: textFieldStyle(
                  context,
                  radius: const BorderRadius.all(Radius.zero)
              ).copyWith(
                  labelText: aL?.registerFirstName
              ),
              style: Theme.of(context).textTheme.labelLarge,
              controller: viewModel.firstName,
              validator: (v) {
                if (v!.isEmpty) return aL?.formFieldEmpty(aL.registerFirstName);
                return null;
              },
            ),
            TextFormField(
              decoration: textFieldStyle(
                  context,
                  radius: const BorderRadius.all(Radius.zero)
              ).copyWith(
                  labelText: aL?.registerLastName
              ),
              style: Theme.of(context).textTheme.labelLarge,
              controller: viewModel.lastName,
              validator: (v) {
                if (v!.isEmpty) return aL?.formFieldEmpty(aL.registerLastName);
                return null;
              },
            ),
            TextFormField(
              decoration: textFieldStyle(
                context,
                radius: BorderRadius.only(
                    bottomLeft: Radius.circular(0.5.rdp()),
                    bottomRight: Radius.circular(0.5.rdp())
                )
              ).copyWith(
                  labelText: aL?.registerPhoneNumber
              ),
              style: Theme.of(context).textTheme.labelLarge,
              controller: viewModel.phoneNumber,
              validator: (v) {
                if (v!.isEmpty) return aL?.formFieldEmpty(aL.registerPhoneNumber);
                return null;
              },
            ),
          ].spacedBy(2),
        ),
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
      ].spacedBy(0.5.rdp()),
    );
  }

  @override
  void handleNavigationEvent(RegisterNavigation event) {
    event.when(
      home: () {
        Navigator.of(context).popUntil((route) => true);
        Navigator.of(context).pushNamed("/nav");
      },
      login: () {
        Navigator.of(context).popUntil((route) => true);
        Navigator.of(context).pushNamed("/login");
      }
    );
  }

}