
import 'package:fireapp/presentation/server_url/server_url_navigation.dart';
import 'package:fireapp/presentation/server_url/server_url_view_model.dart';
import 'package:flutter/material.dart';
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
import 'package:fireapp/base/spaced_by.dart';

import '../../domain/request_state.dart';
import '../../widgets/fill_width.dart';
import '../../widgets/request_state_spinner.dart';
import '../../widgets/standard_button.dart';

class ServerUrlPage extends StatefulWidget {

  const ServerUrlPage({super.key});

  @override
  State createState() => _ServerUrlPage();

}

class _ServerUrlPage
    extends FireAppState<ServerUrlPage>
    with Navigable<ServerUrlNavigation, ServerUrlPage>
    implements ViewModelHolder<ServerUrlViewModel>
{

  @override
  ServerUrlViewModel viewModel = GetIt.instance.get();
  final GlobalKey _formKey = GlobalKey<FormState>(); // Used to submit inputs

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
            buildUrlForm(context)
          ].spacedBy(1.rdp()),
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
          onPressed: () => viewModel.submit(),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)?.registerSubmit ?? ""),
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
    ];
  }

  Widget buildUrlForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          FillWidth(
            child: Text(
              AppLocalizations.of(context)?.serverUrlBlurb ?? "",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          SizedBox(height: 0.5.rdp(),),
          TextFormField(
            decoration: textFieldStyle(
                context,
            ).copyWith(
              hintText: AppLocalizations.of(context)?.serverUrlHint ?? "",
            ),
            style: Theme.of(context).textTheme.labelLarge,
            controller: viewModel.url,
            validator: (v) {
              if (v!.isEmpty) {
                return 'Must not be empty';
              }
              return null;
            },
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
          ),
          SizedBox(height: 0.5.rdp()),
          FillWidth(
            child: Text(
              AppLocalizations.of(context)?.serverUrlRemove ?? "",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void handleNavigationEvent(ServerUrlNavigation event) {
    event.when(
        home: () {
          Navigator.of(context).popUntil((route) => true);
          Navigator.of(context).pushNamed("/login");
        }
    );
  }

}