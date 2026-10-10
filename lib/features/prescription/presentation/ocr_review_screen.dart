import 'package:flutter/material.dart';

class OcrReviewScreen extends StatelessWidget {
  const OcrReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OCR review')),
      body: const Center(
        child: Text('Prescription image and OCR text (P1-04).'),
      ),
    );
  }
}
