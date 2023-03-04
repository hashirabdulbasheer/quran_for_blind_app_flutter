import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'screens/surah_list_screen.dart';

void main() {
  runApp(const MyApp());
  RendererBinding.instance.ensureSemantics();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // showSemanticsDebugger: true,
        title: 'Noble Quran',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Colors.white,
            colorScheme: const ColorScheme.dark(),
            appBarTheme: const AppBarTheme(color: Colors.black),
            textTheme: const TextTheme(
                titleLarge: TextStyle(
                    fontSize: 50, color: Colors.white, fontFamily: "Alvi"),
                bodyLarge: TextStyle(fontSize: 40, color: Colors.black))),
        home: const QBSurahListScreen());
  }
}
