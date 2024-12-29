import 'package:flutter/material.dart';
import 'package:royal_mail_web/pages/jumio_verification_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jumio',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/jumio': (context) => const JumioVerificationPage(),
      },
    );
  }
}