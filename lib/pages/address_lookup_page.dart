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

        // Add Royal Mail CSS
        final styleElement = html.StyleElement();
        styleElement.text = '''
          .address-lookup {
            max-width: 500px;
            margin: 0 auto;
            padding: 20px;
          }
          .address-lookup label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
          }
          .address-lookup input {
            width: 100%;
            padding: 8px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
          }
          .address-lookup select {
            width: 100%;
            padding: 8px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
          }
        ''';
        html.document.head?.appendChild(styleElement);
        
        // Add Royal Mail script
        final script = html.ScriptElement()
          ..src = 'https://ws.addressnow.co.uk/js/addressnow-2.20.min.js'
          ..type = 'text/javascript';
        html.document.head?.appendChild(script);
        
        // Create the HTML structure
        container.innerHTML = '''
          <div class="address-lookup">
            <div>
              <label for="postcode-lookup">Enter Postcode:</label>
              <input 
                type="text" 
                id="postcode-lookup" 
                placeholder="Enter postcode"
                class="addressnow"
                style="width: 100%;"
              />
            </div>
            <div id="address-fields" style="display: none;">
              <label for="address-line1">Address Line 1:</label>
              <input type="text" id="address-line1" readonly />
              
              <label for="address-line2">Address Line 2:</label>
              <input type="text" id="address-line2" readonly />
              
              <label for="city">City:</label>
              <input type="text" id="city" readonly />
              
              <label for="postcode">Postcode:</label>
              <input type="text" id="postcode" readonly />
            </div>
          </div>
        ''';

        // Initialize AddressNow after a short delay to ensure the script is loaded
        html.window.onLoad.listen((_) {
          js.context.callMethod('AddressNow', [
            {
              'key': 'YOUR-API-KEY-HERE',
              'bar': js.context['document'].callMethod('getElementById', ['postcode-lookup']),
              'callback': js.allowInterop((address) {
                // Update the address fields
                js.context['document']
                    .callMethod('getElementById', ['address-line1'])
                    .setAttribute('value', address['line1'] ?? '');
                js.context['document']
                    .callMethod('getElementById', ['address-line2'])
                    .setAttribute('value', address['line2'] ?? '');
                js.context['document']
                    .callMethod('getElementById', ['city'])
                    .setAttribute('value', address['town'] ?? '');
                js.context['document']
                    .callMethod('getElementById', ['postcode'])
                    .setAttribute('value', address['postcode'] ?? '');

                // Show the address fields
                js.context['document']
                    .callMethod('getElementById', ['address-fields'])
                    .style
                    .display = 'block';

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
        });

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