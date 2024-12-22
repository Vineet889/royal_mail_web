import 'package:flutter/material.dart';

class AddressDetailsPage extends StatelessWidget {
  const AddressDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final address = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Address Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              initialValue: address['line1'],
              decoration: const InputDecoration(labelText: 'Address Line 1'),
              readOnly: true,
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: address['line2'],
              decoration: const InputDecoration(labelText: 'Address Line 2'),
              readOnly: true,
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: address['city'],
              decoration: const InputDecoration(labelText: 'City'),
              readOnly: true,
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: address['postcode'],
              decoration: const InputDecoration(labelText: 'Postcode'),
              readOnly: true,
            ),
          ],
        ),
      ),
    );
  }
} 