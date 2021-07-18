import 'dart:convert';
import 'dart:isolate';

import 'package:http/http.dart' as http;

class RequestsHomePage {
  static void calledGithub(SendPort messager) async {
    final client = http.Client();
    final response =
        await client.get(Uri.parse('https://api.github.com/users/iranjunior'));

    messager.send(jsonDecode(response.body));
  }
}
