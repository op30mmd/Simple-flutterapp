// main.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HTTP Request Builder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const RequestBuilderPage(),
    );
  }
}

class RequestBuilderPage extends StatefulWidget {
  const RequestBuilderPage({super.key});

  @override
  State<RequestBuilderPage> createState() => _RequestBuilderPageState();
}

class _RequestBuilderPageState extends State<RequestBuilderPage> {
  final _urlController = TextEditingController();
  final _bodyController = TextEditingController();
  final _headerKeyController = TextEditingController();
  final _headerValueController = TextEditingController();
  String _selectedMethod = 'GET';
  String _response = '';
  bool _isLoading = false;
  Map<String, String> _headers = {};

  final _methods = ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'];

  Future<void> _makeRequest() async {
    if (_urlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a URL')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _response = '';
    });

    try {
      final uri = Uri.parse(_urlController.text);
      late http.Response response;

      switch (_selectedMethod) {
        case 'GET':
          response = await http.get(uri, headers: _headers);
          break;
        case 'POST':
          response = await http.post(
            uri,
            headers: _headers,
            body: _bodyController.text,
          );
          break;
        case 'PUT':
          response = await http.put(
            uri,
            headers: _headers,
            body: _bodyController.text,
          );
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: _headers);
          break;
        case 'PATCH':
          response = await http.patch(
            uri,
            headers: _headers,
            body: _bodyController.text,
          );
          break;
      }

      setState(() {
        try {
          // Try to format JSON response
          final jsonResponse = json.decode(response.body);
          _response = const JsonEncoder.withIndent('  ').convert(jsonResponse);
        } catch (e) {
          // If not JSON, show raw response
          _response = response.body;
        }
      });
    } catch (e) {
      setState(() {
        _response = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addHeader() {
    if (_headerKeyController.text.isNotEmpty && 
        _headerValueController.text.isNotEmpty) {
      setState(() {
        _headers[_headerKeyController.text] = _headerValueController.text;
        _headerKeyController.clear();
        _headerValueController.clear();
      });
    }
  }

  void _removeHeader(String key) {
    setState(() {
      _headers.remove(key);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HTTP Request Builder'),
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // URL and Method Row
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _urlController,
                    decoration: const InputDecoration(
                      labelText: 'URL',
                      hintText: 'https://api.example.com',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedMethod,
                    decoration: const InputDecoration(
                      labelText: 'Method',
                      border: OutlineInputBorder(),
                    ),
                    items: _methods.map((String method) {
                      return DropdownMenuItem<String>(
                        value: method,
                        child: Text(method),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedMethod = newValue;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Headers Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Headers',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _headerKeyController,
                            decoration: const InputDecoration(
                              labelText: 'Key',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _headerValueController,
                            decoration: const InputDecoration(
                              labelText: 'Value',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _addHeader,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _headers.entries.map((entry) {
                        return Chip(
                          label: Text('${entry.key}: ${entry.value}'),
                          onDeleted: () => _removeHeader(entry.key),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Request Body
            if (_selectedMethod != 'GET')
              TextField(
                controller: _bodyController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Request Body',
                  hintText: 'Enter request body (JSON)',
                  border: OutlineInputBorder(),
                ),
              ),

            const SizedBox(height: 16),

            // Send Button
            ElevatedButton(
              onPressed: _isLoading ? null : _makeRequest,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Send Request'),
            ),

            const SizedBox(height: 16),

            // Response Section
            Expanded(
              child: Card(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Response',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SelectableText(_response),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    _bodyController.dispose();
    _headerKeyController.dispose();
    _headerValueController.dispose();
    super.dispose();
  }
}
