import 'dart:async';

import 'package:blocks/game.dart';
import 'package:blocks/game_notifier.dart';
import 'package:blocks/game_pieces.dart';
import 'package:blocks/game_ui.dart';
import 'package:blocks/block_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  GameNotifier boardStateNotifier = GameNotifier(createGamePieceProvider());

  runApp(const BlockGame()); //MyApp(boardStateNotifier));

  Duration frameRate = const Duration(milliseconds: 300);
  Timer.periodic(frameRate, (timer) {
    boardStateNotifier.tick();
    if (boardStateNotifier.gameState == GameState.gameOver) {
      timer.cancel();
    }
  });

  ServicesBinding.instance.keyboard.addHandler(
    (event) {
      if (event is KeyDownEvent) {
        switch (event.logicalKey) {
          case LogicalKeyboardKey.arrowLeft:
            boardStateNotifier.moveLeft();
            break;
          case LogicalKeyboardKey.arrowRight:
            boardStateNotifier.moveRight();
            break;
          case LogicalKeyboardKey.arrowUp:
            boardStateNotifier.rotate();
            break;
          case LogicalKeyboardKey.arrowDown:
            boardStateNotifier.tick();
            break;
        }
      }
      return false;
    },
  );
}

class MyApp extends StatelessWidget {
  final GameNotifier _boardStateNotifier;

  const MyApp(this._boardStateNotifier, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
      body: GameUI(_boardStateNotifier),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              onPressed: () => _boardStateNotifier.moveLeft(),
              icon: const Icon(
                Icons.arrow_left,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () => _boardStateNotifier.rotate(),
              icon: const Icon(
                Icons.rotate_right,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () => _boardStateNotifier.moveRight(),
              icon: const Icon(
                Icons.arrow_right,
                color: Colors.white,
              ))
        ],
      ),
    ));
  }
}
