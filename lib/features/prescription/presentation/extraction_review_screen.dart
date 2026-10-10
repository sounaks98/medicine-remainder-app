import 'package:flutter/material.dart';

class ExtractionReviewScreen extends StatelessWidget {
  const ExtractionReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Review extraction')),
      body: const Center(
        child: Text('Field-level edit and warnings (P4-03).'),
      ),
    );
  }
}
