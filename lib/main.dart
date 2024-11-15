import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HTTP Request App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: HttpRequestPage(),
    );
  }
}

class HttpRequestPage extends StatefulWidget {
  @override
  _HttpRequestPageState createState() => _HttpRequestPageState();
}

class _HttpRequestPageState extends State<HttpRequestPage> {
  final TextEditingController _urlController = TextEditingController();
  String _response = '';

  Future<void> _makeRequest(String method) async {
    try {
      final url = Uri.parse(_urlController.text);
      http.Response response;

      switch (method) {
        case 'GET':
          response = await http.get(url);
          break;
        case 'POST':
          response = await http.post(url, body: {'key': 'value'});
          break;
        case 'PUT':
          response = await http.put(url, body: {'key': 'updated value'});
          break;
        case 'DELETE':
          response = await http.delete(url);
          break;
        default:
          throw 'Unsupported HTTP method';
      }

      setState(() {
        _response = 'Status Code: ${response.statusCode}\n\nBody:\n${response.body}';
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
        title: Text('HTTP Request App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'Enter URL',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _makeRequest('GET'),
                  child: Text('GET'),
                ),
                ElevatedButton(
                  onPressed: () => _makeRequest('POST'),
                  child: Text('POST'),
                ),
                ElevatedButton(
                  onPressed: () => _makeRequest('PUT'),
                  child: Text('PUT'),
                ),
                ElevatedButton(
                  onPressed: () => _makeRequest('DELETE'),
                  child: Text('DELETE'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _response,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
