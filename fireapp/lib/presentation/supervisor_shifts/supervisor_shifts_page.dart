import 'package:fireapp/presentation/supervisor_shifts/supervisor_shifts_view_model.dart';
import 'package:flutter/material.dart';

class SupervisorShiftsPage extends StatelessWidget {
  const SupervisorShiftsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = SupervisorShiftsViewModel();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Supervisor Shifts'),
      ),
      body: const Center(
        child: Text(
          'Shifts management view here',
          style: TextStyle(fontSize: 24),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () async {
            // Call the view model's method to handle the API call
            await viewModel.optimiseShifts();
          },
          child: const Text('Optimise Shifts'),
        ),
      ),
    );
  }
}
