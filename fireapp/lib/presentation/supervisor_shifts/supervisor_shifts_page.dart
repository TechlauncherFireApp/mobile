import 'package:fireapp/presentation/supervisor_shifts/supervisor_shifts_view_model.dart';
import 'package:fireapp/style/theme.dart';
import 'package:fireapp/style/typography.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../domain/request_state.dart'; // Ensure you import the RequestState to use the state classes

class SupervisorShiftsPage extends StatelessWidget {
  const SupervisorShiftsPage({super.key});

  @override
  Widget build(BuildContext context) {
    SupervisorShiftsViewModel viewModel = GetIt.instance.get();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Supervisor Shifts'),
      ),
      body: Center(
        child: Text(
          'Shifts management view here',
          style: textTheme.bodyMedium,
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.0), // Adjusted padding for better UI layout
        child: StreamBuilder<RequestState<void>>(
          stream: viewModel.loadingState,
          builder: (context, data) {
            if (data is LoadingRequestState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ElevatedButton(
              onPressed: () async {
                await viewModel.optimiseShifts();
              },
              child: const Text('Optimise Shifts'),
            );
          },
        ),
      ),
    );
  }
}
