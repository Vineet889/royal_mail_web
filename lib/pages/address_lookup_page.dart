import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;
import 'dart:js' as js;

class AddressLookupPage extends StatefulWidget {
  const AddressLookupPage({super.key});

  @override
  State<AddressLookupPage> createState() => _AddressLookupPageState();
}

class _AddressLookupPageState extends State<AddressLookupPage> {
  bool _isAddressSelected = false;
  Map<String, dynamic>? _selectedAddress;

  @override
  void initState() {
    super.initState();
    // Register the HTML view
    ui.platformViewRegistry.registerViewFactory(
      'royal-mail-widget',
      (int viewId) {
        final container = html.DivElement()
          ..style.width = '100%'
          ..style.height = '400px';

        // Create the address lookup div
        final addressLookupDiv = html.DivElement()
          ..className = 'address-lookup';

        // Create postcode input section
        final postcodeDiv = html.DivElement();
        final postcodeLabel = html.LabelElement()
          ..htmlFor = 'postcode-lookup'
          ..text = 'Enter Postcode:';
        final postcodeInput = html.InputElement()
          ..id = 'postcode-lookup'
          ..placeholder = 'Enter postcode'
          ..className = 'addressnow'
          ..style.width = '100%';
        postcodeDiv.children.addAll([postcodeLabel, postcodeInput]);

        // Create address fields section
        final addressFieldsDiv = html.DivElement()
          ..id = 'address-fields'
          ..style.display = 'none';

        // Create address input fields
        final fields = [
          {'id': 'address-line1', 'label': 'Address Line 1:'},
          {'id': 'address-line2', 'label': 'Address Line 2:'},
          {'id': 'city', 'label': 'City:'},
          {'id': 'postcode', 'label': 'Postcode:'},
        ];

        for (var field in fields) {
          final label = html.LabelElement()
            ..htmlFor = field['id']!
            ..text = field['label']!;
          final input = html.InputElement()
            ..id = field['id']!
            ..readOnly = true;
          addressFieldsDiv.children.addAll([label, input]);
        }

        // Add all elements to the container
        addressLookupDiv.children.addAll([postcodeDiv, addressFieldsDiv]);
        container.children.add(addressLookupDiv);

        // Initialize AddressNow
        js.context.callMethod('AddressNow', [
          {
            'key': 'YOUR-API-KEY-HERE',
            'bar': postcodeInput,
            'callback': js.allowInterop((address) {
              // Update the address fields
              (html.document.getElementById('address-line1') as html.InputElement)
                  .value = address['line1'] ?? '';
              (html.document.getElementById('address-line2') as html.InputElement)
                  .value = address['line2'] ?? '';
              (html.document.getElementById('city') as html.InputElement)
                  .value = address['town'] ?? '';
              (html.document.getElementById('postcode') as html.InputElement)
                  .value = address['postcode'] ?? '';

              // Show the address fields
              html.document.getElementById('address-fields')!.style.display = 'block';

              // Update Flutter state
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
      appBar: AppBar(title: const Text('Address Lookup')),
      body: Column(
        children: [
          Expanded(
            child: HtmlElementView(viewType: 'royal-mail-widget'),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
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
          ),
        ],
      ),
    );
  }
} 