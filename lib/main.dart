import 'dart:async';

import 'package:blocks/game.dart';
import 'package:blocks/game_notifier.dart';
import 'package:blocks/game_pieces.dart';
import 'package:blocks/block_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  GameNotifier boardStateNotifier = GameNotifier(createGamePieceProvider());

  runApp(const BlockGame());

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
