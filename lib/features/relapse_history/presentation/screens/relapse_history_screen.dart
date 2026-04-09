import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/app_typography.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: const Center(
        child: Text(
          'History Screen',
          style: AppTypography.heading3,
        ),
      ),
    );
  }
}