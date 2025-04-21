import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:wordleclone/app/app_colors.dart';
import 'package:wordleclone/wordle/data/word_list.dart';
import 'package:wordleclone/wordle/model/letter_model.dart';
import 'package:wordleclone/wordle/model/word_model.dart';
import 'package:wordleclone/wordle/widget/board.dart';
import 'package:wordleclone/wordle/widget/keyboard.dart';

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
  final List<List<GlobalKey<FlipCardState>>> flipCardKeys = List.generate(
    6,
    (_) => List.generate(5, (_) => GlobalKey<FlipCardState>()),
  );
  int currentWordIndex = 0;

  Word? get currentword =>
      currentWordIndex < board.length ? board[currentWordIndex] : null;

  Word solution = Word.fromString(
    fiveLetterWords[Random().nextInt(fiveLetterWords.length)].toUpperCase(),
  );

  final Set<Letter> keyboardLetters = {};
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Board(board: board, flipCardKeys: flipCardKeys),
          const SizedBox(height: 80),
          Keyboard(
            onKeyTapped: onKeyTapped,
            onDeleteTapped: onDeleteTapped,
            onEnterTapped: onEnterTapped,
            letters: keyboardLetters,
          ),
        ],
      ),
    );
  }

  void onKeyTapped(String val) {
    if (gameStatus == GameStatus.playing) {
      setState(() => currentword?.addLetter(val));
    }
  }

  void onDeleteTapped() {
    if (gameStatus == GameStatus.playing) {
      setState(() => currentword?.removeLetter());
    }
  }

  Future<void> onEnterTapped() async {
    if (gameStatus == GameStatus.playing &&
        currentword != null &&
        !currentword!.letters.contains(Letter.empty())) {
      gameStatus = GameStatus.submitting;

      for (var i = 0; i < currentword!.letters.length; i++) {
        final currentWordLetter = currentword!.letters[i];
        final currentSolutionLetter = solution.letters[i];

        setState(() {
          if (currentWordLetter == currentSolutionLetter) {
            currentword!.letters[i] = currentWordLetter.copyWith(
              status: LetterStatus.correct,
            );
          } else if (solution.letters.contains(currentWordLetter)) {
            currentword!.letters[i] = currentWordLetter.copyWith(
              status: LetterStatus.inWord,
            );
          } else {
            currentword!.letters[i] = currentWordLetter.copyWith(
              status: LetterStatus.notInword,
            );
          }
        });

        final letter = keyboardLetters.firstWhere(
          (e) => e.val == currentWordLetter.val,
          orElse: () => Letter.empty(),
        );
        if (letter.status != LetterStatus.correct) {
          keyboardLetters.removeWhere((e) => e.val == currentWordLetter.val);
          keyboardLetters.add(currentword!.letters[i]);
        }
        await Future.delayed(
          const Duration(milliseconds: 150),
          () => flipCardKeys[currentWordIndex][i].currentState?.toggleCard(),
        );
      }
      checkwinorloss();
    }
  }

  void checkwinorloss() {
    if (currentword!.wordString == solution.wordString) {
      gameStatus = GameStatus.won;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          dismissDirection: DismissDirection.none,
          duration: const Duration(days: 1),
          backgroundColor: correctColor,
          content: const Text(
            'You Won',
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
          action: SnackBarAction(
            label: 'New Game',
            onPressed: restart,
            textColor: const Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      );
    } else if (currentWordIndex + 1 >= board.length) {
      gameStatus = GameStatus.lost;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          dismissDirection: DismissDirection.none,
          duration: const Duration(days: 1),
          backgroundColor: Colors.redAccent[200],
          content: Text(
            'You Lost, Solution : ${solution.wordString}',
            style: const TextStyle(color: Colors.white),
          ),
          action: SnackBarAction(
            label: 'New Game',
            onPressed: restart,
            textColor: Colors.white,
          ),
        ),
      );
    } else {
      gameStatus = GameStatus.playing;
    }
    currentWordIndex += 1;
  }

  void restart() {
    setState(() {
      gameStatus = GameStatus.playing;
      currentWordIndex = 0;
      board
        ..clear()
        ..addAll(
          List.generate(
            6,
            (_) => Word(letters: List.generate(5, (_) => Letter.empty())),
          ),
        );
    });
    solution = Word.fromString(
      fiveLetterWords[Random().nextInt(fiveLetterWords.length)].toUpperCase(),
    );
    flipCardKeys
      ..clear()
      ..addAll(
        List.generate(
          6,
          (_) => List.generate(5, (_) => GlobalKey<FlipCardState>()),
        ),
      );
    keyboardLetters.clear();
  }
}
