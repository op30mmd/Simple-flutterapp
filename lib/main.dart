import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const HttpRequestApp());
}

class HttpRequestApp extends StatelessWidget {
  const HttpRequestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HTTP Request App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HttpRequestScreen(),
    );
  }
}

class HttpRequestScreen extends StatefulWidget {
  const HttpRequestScreen({super.key});

  @override
  State<HttpRequestScreen> createState() => _HttpRequestScreenState();
}

class _HttpRequestScreenState extends State<HttpRequestScreen> {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  String _response = '';

  Future<void> _makeRequest(String method) async {
    final url = Uri.parse(_urlController.text.trim());
    final body = _bodyController.text.trim();

    try {
      http.Response response;

      switch (method) {
        case 'GET':
          response = await http.get(url);
          break;
        case 'POST':
          response = await http.post(url, body: body);
          break;
        case 'PUT':
          response = await http.put(url, body: body);
          break;
        case 'DELETE':
          response = await http.delete(url);
          break;
        default:
          setState(() {
            _response = 'Unsupported method';
          });
          return;
      }

      setState(() {
        _response = 'Status: ${response.statusCode}\nBody:\n${response.body}';
      });
    } catch (e) {
      setState(() {
        _response = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HTTP Request App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'URL',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _bodyController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Body (for POST/PUT)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: [
                ElevatedButton(
                  onPressed: () => _makeRequest('GET'),
                  child: const Text('GET'),
                ),
                ElevatedButton(
                  onPressed: () => _makeRequest('POST'),
                  child: const Text('POST'),
                ),
                ElevatedButton(
                  onPressed: () => _makeRequest('PUT'),
                  child: const Text('PUT'),
                ),
                ElevatedButton(
                  onPressed: () => _makeRequest('DELETE'),
                  child: const Text('DELETE'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _response,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
