import 'package:flutter/material.dart';
import 'package:royal_mail_web/pages/address_lookup_page.dart';
import 'package:royal_mail_web/pages/address_details_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Royal Mail Address Lookup',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AddressLookupPage(),
        '/details': (context) => const AddressDetailsPage(),
      },
    );
  }
}