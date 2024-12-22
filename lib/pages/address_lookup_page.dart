import 'package:flutter/material.dart';
import 'dart:js' as js;

class AddressLookupPage extends StatefulWidget {
  const AddressLookupPage({super.key});

  @override
  State<AddressLookupPage> createState() => _AddressLookupPageState();
}

class _AddressLookupPageState extends State<AddressLookupPage> {
  final TextEditingController _controller = TextEditingController();
  bool _isAddressSelected = false;
  Map<String, dynamic>? _selectedAddress;

  @override
  void initState() {
    super.initState();
    // Set up the callback for address selection
    js.context['addressSelectedCallback'] = (address) {
      setState(() {
        _isAddressSelected = true;
        _selectedAddress = {
          'line1': address['line1'] ?? '',
          'line2': address['line2'] ?? '',
          'city': address['town'] ?? '',
          'postcode': address['postcode'] ?? '',
        };
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Address Lookup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter Postcode',
                border: OutlineInputBorder(),
              ),
              onTap: () {
                // Initialize AddressNow when the TextField is tapped
                js.context.callMethod('initializeAddressNow', ['flutter-textfield']);
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isAddressSelected
                  ? () {
                      Navigator.pushNamed(
                        context,
                        '/details',
                        arguments: _selectedAddress,
                      );
                    }
                  : null,
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
} 