import 'dart:async';

import 'package:blocks/game.dart';
import 'package:blocks/game_ui.dart';
import 'package:blocks/piece.dart';
import 'package:flutter/material.dart';

void main() {
  BoardStateNotifier boardStateNotifier = BoardStateNotifier();

  runApp(MyApp(boardStateNotifier));

  Duration frameRate = const Duration(milliseconds: 100);
  Timer.periodic(frameRate, (timer) {
    boardStateNotifier.tick();
    if (boardStateNotifier.gameState == GameState.gameOver) {
      timer.cancel();
    }
  });
}

class BoardStateNotifier extends ChangeNotifier {
  late Game _game;
  BoardState get boardState => _game.getBoardState();
  GameState get gameState => _game.getState();

  BoardStateNotifier() {
    _game = Game.empty(
        _createPieceProvider(Piece([
          PieceSprite(['P'])
        ])),
        10,
        15);
  }

  static Iterable<Piece> _createPieceProvider(Piece piece) sync* {
    while (true) {
      yield piece;
    }
  }

  void tick() {
    _game.tick();
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  final BoardStateNotifier _boardStateNotifier;

  const MyApp(this._boardStateNotifier, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GameUI(_boardStateNotifier),
    );
  }
}
