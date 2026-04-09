import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/app_typography.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Journal')),
      body: const Center(
        child: Text(
          'Journal Screen',
          style: AppTypography.heading3,
        ),
      ),
    );
  }
}