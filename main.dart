import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Data Fetch Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ApiDataFetchScreen(endpoint: 'posts', screenName: 'Posts Screen'),
    );
  }
}
