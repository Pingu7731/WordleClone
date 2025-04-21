import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wordleclone/wordle/data/word_list.dart';
import 'package:wordleclone/wordle/model/letter_model.dart';
import 'package:wordleclone/wordle/model/word_model.dart';
import 'package:wordleclone/wordle/widget/board.dart';

enum GameStatus { playing, submitting, lost, won }

class WordleScreen extends StatefulWidget {
  const WordleScreen({super.key});

  @override
  State<WordleScreen> createState() => _WordleScreenState();
}

class _WordleScreenState extends State<WordleScreen> {
  GameStatus gameStatus = GameStatus.playing;

  final List<Word> board = List.generate(
    6,
    (_) => Word(letters: List.generate(5, (_) => Letter.empty())),
  );
  int currentWordIndex = 0;

  Word? get currentword =>
      currentWordIndex < board.length ? board[currentWordIndex] : null;

  Word solution = Word.fromString(
    fiveLetterWords[Random().nextInt(fiveLetterWords.length)].toUpperCase(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'WORDLE',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
      ),
      body: Column(children: [Board(board: [])]),
    );
  }
}
