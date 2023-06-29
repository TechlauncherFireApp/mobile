
import 'package:fireapp/base/spaced_by.dart';
import 'package:fireapp/base/widget.dart';
import 'package:fireapp/domain/models/reference/gender.dart';
import 'package:fireapp/presentation/fireapp_page.dart';
import 'package:fireapp/presentation/register/register_navigation.dart';
import 'package:fireapp/presentation/register/register_view_model.dart';
import 'package:fireapp/widgets/form/form_field_lockup.dart';
import 'package:fireapp/widgets/form/password_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:email_validator/email_validator.dart';

import '../../domain/request_state.dart';

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
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  AppLocalizations.of(context)?.registerTitle ?? "",
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                )
            ),
            Form(
              key: _formKey,
              child: _buildForm(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    var aL = AppLocalizations.of(context);
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(labelText: aL?.registerUsername ?? ""),
          controller: viewModel.email,
          validator: (v) {
            if (v!.isEmpty) return aL?.formFieldEmpty(aL.registerUsername);
            if (EmailValidator.validate(v)) return aL?.formFieldNotEmail(aL.registerUsername);
            return null;
          },
          keyboardType: TextInputType.emailAddress,
        ),
        PasswordFormField(
          controller: viewModel.password,
          validator: (v) {
            if (v!.isEmpty) return aL?.formFieldEmpty(aL.registerPassword);
            return null;
          },
          label: aL?.registerPassword ?? "",
        ),
        TextFormField(
          decoration: InputDecoration(labelText: aL?.registerFirstName ?? ""),
          controller: viewModel.firstName,
          validator: (v) {
            if (v!.isEmpty) return aL?.formFieldEmpty(aL.registerFirstName);
            return null;
          },
        ),
        TextFormField(
          decoration: InputDecoration(labelText: aL?.registerLastName ?? ""),
          controller: viewModel.lastName,
          validator: (v) {
            if (v!.isEmpty) return aL?.formFieldEmpty(aL.registerLastName);
            return null;
          },
        ),
        TextFormField(
          decoration: InputDecoration(labelText: aL?.registerFirstName ?? ""),
          controller: viewModel.firstName,
          validator: (v) {
            if (v!.isEmpty) return aL?.formFieldEmpty(aL.registerFirstName);
            return null;
          },
        ),
        TextFormField(
          decoration: InputDecoration(labelText: aL?.registerPhoneNumber ?? ""),
          controller: viewModel.firstName,
          validator: (v) {
            if (v!.isEmpty) return aL?.formFieldEmpty(aL.registerPhoneNumber);
            return null;
          },
        ),
        StreamBuilder<GenderOption?>(
          stream: viewModel.gender,
          builder: (context, selectedGender) {
            return DropdownButton<GenderOption>(
              hint: Text(AppLocalizations.of(context)?.registerGenderSelect ?? ""),
              items: GenderOption.genders.map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e.label),
                  onTap: () { viewModel.setGender(e); },
                )
              ).toList(),
              onChanged: (value) {
                viewModel.setGender(value);
              },
              isExpanded: true,
              value: selectedGender.data,
              iconSize: 48,
            );
          }
        ),
        _buildSubmitButton()
      ].spacedBy(30),
    );
  }
  
  Widget _buildSubmitButton() {
    return StreamBuilder(
      stream: viewModel.state,
      builder: (context, state) {
        if (!state.hasData) return Container();
        var data = state;
        
        var onPressed = (data is! LoadingRequestState) ? () {
          if ((_formKey.currentState as FormState).validate()) {
            viewModel.register();
          }
        } : null;
        
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(40), // fromHeight use double.infinity as width and 40 is the height
          ),
          onPressed: onPressed,
          child: Text(AppLocalizations.of(context)?.registerSubmit ?? ""),
        );
      },
    );
  }

  @override
  void handleNavigationEvent(RegisterNavigation event) {
    event.when(
      home: () {
        Navigator.of(context).popUntil((route) => true);
        Navigator.of(context).pushNamed("/nav");
      }
    );
  }

}