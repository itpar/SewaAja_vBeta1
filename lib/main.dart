import 'package:flutter/material.dart';
import 'package:alco_safe/ui/routes.dart';
import 'package:alco_safe/Splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alco Safe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      routes: routes,
    );
  }
}