import 'package:flutter/material.dart';

import 'package:medicine_remainder_app/features/prescription/presentation/capture_screen.dart';

class MedicineListScreen extends StatelessWidget {
  const MedicineListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Medicines')),
      body: const Center(
        child: Text('No confirmed medicines yet.'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const CaptureScreen(),
            ),
          );
        },
        tooltip: 'Add prescription',
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
