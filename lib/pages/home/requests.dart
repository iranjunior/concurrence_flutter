import 'dart:convert';
import 'dart:isolate';

import 'package:http/http.dart' as http;

class RequestsHomePage {
  // Recebe como paramentro o messageiro mostrado na
  // página anterior
  static void calledGithub(SendPort messager) async {
    final client = http.Client();
    final response = await client.get(
      Uri.parse(
        'https://api.github.com/users/iranjunior',
      ),
    );
    // envia para a thread principal a resposta
    // no formato de Map
    messager.send(jsonDecode(response.body));
  }
}
