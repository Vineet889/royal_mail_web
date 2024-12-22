import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui_web' as ui;
import 'dart:js' as js;

class AddressLookupPage extends StatefulWidget {
  const AddressLookupPage({super.key});

  @override
  State<AddressLookupPage> createState() => _AddressLookupPageState();
}

class _AddressLookupPageState extends State<AddressLookupPage> {
  bool _isAddressSelected = false;
  Map<String, dynamic>? _selectedAddress;
  final String viewType = 'royal-mail-widget';

  @override
  void initState() {
    super.initState();
    // Register the HTML view
    ui.platformViewRegistry.registerViewFactory(
      viewType,
      (int viewId) {
        final container = html.DivElement()
          ..style.width = '100%'
          ..style.height = '100px';

        // Create the input element
        final input = html.InputElement()
          ..id = 'postcode-lookup'
          ..className = 'addressnow'
          ..style.width = '100%'
          ..style.padding = '8px'
          ..style.border = '1px solid #ccc'
          ..style.borderRadius = '4px'
          ..placeholder = 'Enter your postcode';

        container.children.add(input);

        // Initialize AddressNow
        js.context.callMethod('AddressNow', [
          {
            'key': 'GG36-BF96-ZJ53-EW94',  // Replace with your API key
            'bar': input,
            'onSelect': js.allowInterop((address) {
              print('Address selected: $address'); // Debug print
              setState(() {
                _isAddressSelected = true;
                _selectedAddress = {
                  'line1': address['line1'] ?? '',
                  'line2': address['line2'] ?? '',
                  'city': address['town'] ?? '',
                  'postcode': address['postcode'] ?? '',
                };
              });
            }),
          }
        ]);

        return container;
      },
    );
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
            Container(
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
              child: HtmlElementView(viewType: viewType),
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
} 