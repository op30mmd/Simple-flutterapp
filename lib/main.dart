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
           primarySwatch: Colors.blue,
         ),
         home: HttpRequestScreen(),
       );
     }
   }

   class HttpRequestScreen extends StatefulWidget {
     @override
     _HttpRequestScreenState createState() => _HttpRequestScreenState();
   }

   class _HttpRequestScreenState extends State<HttpRequestScreen> {
     final TextEditingController _urlController = TextEditingController();
     final TextEditingController _bodyController = TextEditingController();
     String _response = '';
     String _method = 'GET';

     Future<void> _makeRequest() async {
       final url = _urlController.text;
       final body = _bodyController.text;

       try {
         http.Response response;
         switch (_method) {
           case 'GET':
             response = await http.get(Uri.parse(url));
             break;
           case 'POST':
             response = await http.post(
               Uri.parse(url),
               body: body.isNotEmpty ? jsonEncode(jsonDecode(body)) : null,
               headers: {'Content-Type': 'application/json'},
             );
             break;
           case 'PUT':
             response = await http.put(
               Uri.parse(url),
               body: body.isNotEmpty ? jsonEncode(jsonDecode(body)) : null,
               headers: {'Content-Type': 'application/json'},
             );
             break;
           case 'DELETE':
             response = await http.delete(Uri.parse(url));
             break;
           default:
             throw Exception('Invalid method');
         }

         setState(() {
           _response = 'Status Code: ${response.statusCode}\nResponse: ${response.body}';
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
                 decoration: InputDecoration(labelText: 'URL'),
               ),
               SizedBox(height: 16),
               DropdownButton<String>(
                 value: _method,
                 onChanged: (String? newValue) {
                   setState(() {
                     _method = newValue!;
                   });
                 },
                 items: <String>['GET', 'POST', 'PUT', 'DELETE']
                     .map<DropdownMenuItem<String>>((String value) {
                   return DropdownMenuItem<String>(
                     value: value,
                     child: Text(value),
                   );
                 }).toList(),
               ),
               SizedBox(height: 16),
               TextField(
                 controller: _bodyController,
                 decoration: InputDecoration(labelText: 'Body (for POST/PUT)'),
                 maxLines: 5,
               ),
               SizedBox(height: 16),
               ElevatedButton(
                 onPressed: _makeRequest,
                 child: Text('Send Request'),
               ),
               SizedBox(height: 16),
               Expanded(
                 child: Text(
                   _response,
                   style: TextStyle(fontSize: 16),
                 ),
               ),
             ],
           ),
         ),
       );
     }
   }
  
