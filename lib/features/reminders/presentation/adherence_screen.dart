import 'package:flutter/material.dart';

class AdherenceScreen extends StatelessWidget {
  const AdherenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adherence')),
      body: const Center(
        child: Text('Taken and skipped history (P6-04).'),
      ),
    );
  }
}
