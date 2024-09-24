import 'package:blocks/game.dart';
import 'package:blocks/piece.dart';
import 'package:flutter/material.dart';

class GameNotifier extends ChangeNotifier {
  late Game _game;
  BoardState get boardState => _game.getBoardState();
  GameState get gameState => _game.getState();

  GameNotifier() {
    _game = Game.empty(
        _createPieceProvider(Piece([
          PieceSprite(['P'])
        ])),
        10,
        15);
  }

  @visibleForTesting
  GameNotifier.fromGame(this._game);

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
