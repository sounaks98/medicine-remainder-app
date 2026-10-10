import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:medicine_remainder_app/app/router.dart';

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
        onPressed: () => context.push(AppRoutes.capture),
        tooltip: 'Add prescription',
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
