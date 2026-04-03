import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // 🔥 test nested navigation
            context.push('/community/post/123');
          },
          child: const Text('Go to Post Details'),
        ),
      ),
    );
  }
}