import 'package:flutter/material.dart';
import 'package:wordleclone/wordle/model/letter_model.dart';

const qwerty = [
  ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
  ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
  ['ENTER', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', 'DEL'],
];

class Keyboard extends StatelessWidget {
  final void Function(String) onKeyTapped;
  final VoidCallback onDeleteTapped;
  final VoidCallback onEnterTapped;

  const Keyboard({
    Key? key,
    required this.onKeyTapped,
    required this.onDeleteTapped,
    required this.onEnterTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          qwerty
              .map(
                (keyRow) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                      keyRow.map((letter) {
                        if (letter == 'DEL') {
                          return KeyboardButton.delete(onTap: onDeleteTapped);
                        } else if (letter == 'ENTER') {
                          return KeyboardButton.enter(onTap: onEnterTapped);
                        }
                        return KeyboardButton(
                          onTap: () => onKeyTapped(letter),
                          letter: letter,
                          backgroundColor: Colors.grey,
                        );
                      }).toList(),
                ),
              )
              .toList(),
    );
  }
}

class KeyboardButton extends StatelessWidget {
  const KeyboardButton({
    Key? key,
    this.height = 48,
    this.width = 30,
    required this.onTap,
    required this.backgroundColor,
    required this.letter,
  }) : super(key: key);

  factory KeyboardButton.delete({required VoidCallback onTap}) =>
      KeyboardButton(
        width: 56,
        onTap: onTap,
        backgroundColor: Colors.grey,
        letter: '⌫',
      );

  factory KeyboardButton.enter({required VoidCallback onTap}) => KeyboardButton(
    width: 56,
    onTap: onTap,
    backgroundColor: Colors.grey,
    letter: 'ENTER',
  );

  final double height;
  final double width;
  final VoidCallback onTap;
  final Color backgroundColor;
  final String letter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 2.0),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: height,
            width: width,
            alignment: Alignment.center,
            child: Text(
              letter,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ),
    );
  }
}
