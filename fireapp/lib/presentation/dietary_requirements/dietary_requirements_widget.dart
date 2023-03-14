
import 'package:fireapp/base/widget.dart';
import 'package:fireapp/presentation/dietary_requirements/dietary_requirements_view_model.dart';
import 'package:fireapp/presentation/fireapp_page.dart';
import 'package:fireapp/widgets/request_state_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

class DietaryRequirementsWidget extends StatefulWidget {

  const DietaryRequirementsWidget({super.key});

  @override
  State createState() => _DietaryRequirementsWidgetState();

}

class _DietaryRequirementsWidgetState extends FireAppState<DietaryRequirementsWidget>
    implements ViewModelHolder<DietaryRequirementsViewModel> {

  @override
  DietaryRequirementsViewModel viewModel = GetIt.instance.get();

  @override
  void initState() {
    super.initState();
    viewModel.load();
  }

  @override
  Widget build(BuildContext context) {
    return RequestStateWidget.stream(
      state: viewModel.requirements,
      retry: () { viewModel.load(); },
      child: (_, restrictions) {
        return Container();
      }
    );
  }

}