import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Scaffold(
        appBar: AppBar(title: Text('Flutter Dockerized')),
        body: Center(child: Text('Hello from Flutter Web!')),
      ),
    );
  }
}
