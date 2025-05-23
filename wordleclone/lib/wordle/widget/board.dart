import 'package:flutter/material.dart';

import 'package:wordleclone/wordle/model/word_model.dart';
import 'package:flip_card/flip_card.dart';
import 'package:wordleclone/wordle/widget/board_tile.dart';
import 'package:wordleclone/wordle/wordle.dart';

class Board extends StatelessWidget {
  const Board({Key? key, required this.board, required this.flipCardKeys})
    : super(key: key);
  final List<Word> board;
  final List<List<GlobalKey<FlipCardState>>> flipCardKeys;
  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          board
              .asMap()
              .map((i, word) {
                return MapEntry(
                  i,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        word.letters
                            .asMap()
                            .map((j, letter) {
                              return MapEntry(
                                j,
                                FlipCard(
                                  key: flipCardKeys[i][j],
                                  flipOnTouch: false,
                                  direction: FlipDirection.VERTICAL,
                                  front: BoardTile(
                                    letter: Letter(
                                      val: letter.val,
                                      status: LetterStatus.initial,
                                    ),
                                  ),
                                  back: BoardTile(letter: letter),
                                ),
                              );
                            })
                            .values
                            .toList(),
                  ),
                );
              })
              .values
              .toList(),
    );
  }
}
