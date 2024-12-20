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
        final container = html.DivElement();
        
        container.innerHtml = '''
          <div style="padding: 20px;">
            <form>
              <div style="margin-bottom: 15px;">
                <label for="postcode-lookup" style="display: block; margin-bottom: 5px;">Enter Postcode:</label>
                <input 
                  type="text" 
                  id="postcode-lookup" 
                  class="addressnow" 
                  style="width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px;"
                  placeholder="Enter postcode"
                />
              </div>
              <div id="selected-address" style="display: none;">
                <div style="margin-bottom: 15px;">
                  <label style="display: block; margin-bottom: 5px;">Address Line 1:</label>
                  <input type="text" id="address-line1" readonly style="width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px;"/>
                </div>
                <div style="margin-bottom: 15px;">
                  <label style="display: block; margin-bottom: 5px;">Address Line 2:</label>
                  <input type="text" id="address-line2" readonly style="width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px;"/>
                </div>
                <div style="margin-bottom: 15px;">
                  <label style="display: block; margin-bottom: 5px;">City:</label>
                  <input type="text" id="city" readonly style="width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px;"/>
                </div>
                <div style="margin-bottom: 15px;">
                  <label style="display: block; margin-bottom: 5px;">Postcode:</label>
                  <input type="text" id="postcode" readonly style="width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px;"/>
                </div>
              </div>
            </form>
          </div>
        ''';

        // Initialize AddressNow
        html.window.onLoad.listen((_) {
          js.context.callMethod('AddressNow', [
            {
              'key': 'YOUR-API-KEY-HERE',
              'bar': html.document.getElementById('postcode-lookup'),
              'callback': js.allowInterop((address) {
                // Show the address fields container
                html.document.getElementById('selected-address')?.style.display = 'block';
                
                // Update the address fields
                (html.document.getElementById('address-line1') as html.InputElement?)
                    ?.value = address['line1'] ?? '';
                (html.document.getElementById('address-line2') as html.InputElement?)
                    ?.value = address['line2'] ?? '';
                (html.document.getElementById('city') as html.InputElement?)
                    ?.value = address['town'] ?? '';
                (html.document.getElementById('postcode') as html.InputElement?)
                    ?.value = address['postcode'] ?? '';

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
            child: const HtmlElementView(viewType: 'royal-mail-widget'),
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