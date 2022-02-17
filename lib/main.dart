import "package:flutter/material.dart";
import "package:provider/provider.dart";

import 'providers/auth.dart';
import 'screens/home.dart';
import 'screens/auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
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
            home: authProvider.isAuth ? const Home() : const AuthScreen(),
          );
        },
      ),
    );
  }
}
