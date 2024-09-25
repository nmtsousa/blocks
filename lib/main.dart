import 'dart:async';
import 'dart:math';

import 'package:blocks/game.dart';
import 'package:blocks/game_notifier.dart';
import 'package:blocks/game_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'piece.dart';

void main() {
  GameNotifier boardStateNotifier = GameNotifier(_createPieceProvider());

  runApp(MyApp(boardStateNotifier));

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

Iterable<Piece> _createPieceProvider() sync* {
  var rng = Random();
  while (true) {
    switch (rng.nextInt(6)) {
      case 0:
        yield Piece([
          PieceSprite([
            'PP',
            'PP',
          ])
        ]);
        break;
      case 1:
        yield Piece([
          PieceSprite([
            'PPP',
            'P  ',
          ]),
          PieceSprite([
            'PP',
            ' P',
            ' P',
          ]),
          PieceSprite([
            '  P',
            'PPP',
          ]),
          PieceSprite([
            'P ',
            'P ',
            'PP',
          ]),
        ]);
        break;
      case 2:
        yield Piece([
          PieceSprite([
            'P  ',
            'PPP',
          ]),
          PieceSprite([
            'PP',
            'P ',
            'P ',
          ]),
          PieceSprite([
            'PPP',
            '  P',
          ]),
          PieceSprite([
            ' P',
            ' P',
            'PP',
          ]),
        ]);
        break;
      case 3:
        yield Piece([
          PieceSprite([
            'PP ',
            ' PP',
          ]),
          PieceSprite([
            ' P',
            'PP',
            'P ',
          ]),
        ]);
        break;
      case 4:
        yield Piece([
          PieceSprite([
            ' PP',
            'PP ',
          ]),
          PieceSprite([
            'P ',
            'PP',
            ' P',
          ]),
        ]);
        break;
      case 5:
        yield Piece([
          PieceSprite([
            'PPPP',
          ]),
          PieceSprite([
            'P',
            'P',
            'P',
            'P',
          ]),
        ]);
        break;
    }
  }
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
