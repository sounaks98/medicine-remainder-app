import 'package:flutter/material.dart';

import 'package:medicine_remainder_app/features/medicines/presentation/medicine_list_screen.dart';

/// Root [MaterialApp] and theme. [ProviderScope] and [go_router] wire-up in P0-03.
class MedicineReminderApp extends StatelessWidget {
  const MedicineReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medicine Reminder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MedicineListScreen(),
    );
  }
}
