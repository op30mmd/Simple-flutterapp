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
      home: const RequestBuilderPage(), // This replaces the default demo page
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
  String _response = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HTTP Request Builder'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'Enter URL',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                try {
                  final response = await http.get(Uri.parse(_urlController.text));
                  setState(() {
                    _response = response.body;
                  });
                } catch (e) {
                  setState(() {
                    _response = 'Error: $e';
                  });
                }
              },
              child: const Text('Send Request'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_response),
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
    super.dispose();
  }
}
