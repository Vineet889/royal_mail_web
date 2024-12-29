import 'package:flutter/material.dart';
import 'dart:js' as js;

class JumioVerificationPage extends StatelessWidget {
  const JumioVerificationPage({super.key});

  void _startVerification() {
    js.context.callMethod('startJumioVerification');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jumio Verification'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _startVerification,
          child: const Text('Start Verification'),
        ),
      ),
    );
  }
} 