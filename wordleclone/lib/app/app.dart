import 'package:flutter/material.dart';
import 'package:wordleclone/wordle/views/wordle_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wordle',
      theme: ThemeData.dark(),
      home: WordleScreen(),
    );
  }
}
