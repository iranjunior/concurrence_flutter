import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isolate_app/pages/home/requests.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> user = {};
  @override
  void initState() {
    super.initState();
  }

  Future calculateNewValue(
      {void Function(Map<String, dynamic>)? onComplete}) async {
    ReceivePort receivePort = ReceivePort();

    final isolate = await Isolate.spawn<SendPort>(
      RequestsHomePage.calledGithub,
      receivePort.sendPort,
    );

    receivePort.listen((event) {
      if (onComplete != null) {
        onComplete(event);
      }
      if (event != null) {
        isolate.kill();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Isolate Exemple'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            user['avatar_url'] != null
                ? CircleAvatar(
                    foregroundImage: NetworkImage(user['avatar_url']),
                    radius: 40,
                  )
                : SizedBox.shrink(),
            Text(
              user['login'] ?? '',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.person),
        onPressed: () => calculateNewValue(onComplete: (response) {
          setState(() {
            user = response;
          });
        }),
      ),
    );
  }
}
