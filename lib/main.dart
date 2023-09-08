import 'package:flutter/material.dart';

import './screens/mainScreen.dart';
import './screens/signInScreen.dart';
import './screens/editScreen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'final64125842',
      initialRoute: '/signIn',
      routes: {
        '/': (context) => MainScreen(),
        '/signIn': (context) => SignInScreen(),
        '/edit': (context) => EditScreen(),
      },
    );
  }
}
