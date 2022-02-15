import "package:flutter/material.dart";
import 'screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Acadme',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: "sans-serif",
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
          ),
          bodyText1: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const Home(),
    );
  }
}
