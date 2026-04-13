import 'package:flutter/material.dart';

void main() {
runApp(const ImGoApp());
}

class ImGoApp extends StatelessWidget {
const ImGoApp({super.key});

@override
Widget build(BuildContext context) {
return MaterialApp(
title: 'ImGo',
theme: ThemeData(
primarySwatch: Colors.blue,
),
home: const HomePage(),
);
}
}

class HomePage extends StatelessWidget {
const HomePage({super.key});

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text('ImGo'),
),
body: Center(
child: Text(
'Welcome to ImGo - One Platform to Manage Every Guest Experience',
textAlign: TextAlign.center,
),
),
);
}
}
