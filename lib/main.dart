import 'package:flutter/material.dart';
import 'package:technical_exam/main/home.dart';
import 'package:technical_exam/main/main_menu.dart';
import 'package:technical_exam/services/shared_services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Technical Exam',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primaryColor: const Color(0xFF202342),
        textTheme: const TextTheme(
            headline1: TextStyle(
              fontSize: 22.0,
              color: Color(0xFFE4EBF8),
            ),
            headline2: TextStyle(
              fontSize: 45.0,
              fontWeight: FontWeight.w700,
              color: Color(0xFF202342),
            ),
            bodyText1: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              color: Color(0xFFE4EBF8),
            )),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFF202342),
          selectionHandleColor: Color(0xFF202342),
          selectionColor: Color(0xFF202342),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const SharedService(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => HomePage(),
        '/menu': (BuildContext context) => const MainMenu(),
      },
    );
  }
}
