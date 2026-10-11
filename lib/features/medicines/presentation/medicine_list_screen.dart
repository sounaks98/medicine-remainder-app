import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:medicine_remainder_app/app/router.dart';

class MedicineListScreen extends StatelessWidget {
  const MedicineListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicines'),
        actions: [
          if (kDebugMode)
            IconButton(
              icon: const Icon(Icons.science_outlined),
              tooltip: 'Gemma 3n LiteRT spike',
              onPressed: () => context.push(AppRoutes.modelSpike),
            ),
        ],
      ),
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
