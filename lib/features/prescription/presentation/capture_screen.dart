import 'package:flutter/material.dart';

class CaptureScreen extends StatelessWidget {
  const CaptureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Capture prescription')),
      body: const Center(
        child: Text('Camera and gallery capture (P1-01).'),
      ),
    );
  }
}
