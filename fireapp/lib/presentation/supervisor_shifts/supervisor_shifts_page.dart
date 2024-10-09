import 'package:fireapp/presentation/supervisor_shifts/supervisor_shifts_view_model.dart';
import 'package:fireapp/style/theme.dart';
import 'package:fireapp/style/typography.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization
import '../../domain/request_state.dart'; // Ensure you import the RequestState to use the state classes

class SupervisorShiftsPage extends StatelessWidget {
  const SupervisorShiftsPage({super.key});

  @override
  Widget build(BuildContext context) {
    SupervisorShiftsViewModel viewModel = GetIt.instance.get();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.supervisor_shifts ?? 'Supervisor Shifts'),
      ),
      body: Center(
        child: Text(
          AppLocalizations.of(context)?.shifts_management_view ?? 'Shifts management view here',
          style: textTheme.bodyMedium,
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(1.0.rdp()),
        child: StreamBuilder(
          stream: viewModel.loadingState,
          builder: (context, snapshot) {
            final data = snapshot.data;
            if (data is LoadingRequestState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ElevatedButton(
              onPressed: () async {
                await viewModel.optimiseShifts();
              },
              child: Text(AppLocalizations.of(context)?.optimise_shifts ?? 'Optimise Shifts'),
            );
          },
        ),
      ),
    );
  }
}
