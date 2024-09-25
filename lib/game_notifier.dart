import 'package:blocks/game.dart';
import 'package:blocks/piece.dart';
import 'package:flutter/material.dart';

class GameNotifier extends ChangeNotifier {
  late Game _game;
  BoardState get boardState => _game.getBoardState();
  GameState get gameState => _game.getState();

  GameNotifier(Iterable<Piece> pieceProvider) {
    _game = Game.empty(pieceProvider, 10, 15);
  }

  @visibleForTesting
  GameNotifier.fromGame(this._game);

  void tick() {
    _game.tick();
    notifyListeners();
  }

  void moveLeft() {
    _game.moveLeft();
    notifyListeners();
  }

  void rotate() {
    _game.rotatePiece();
    notifyListeners();
  }

  moveRight() {
    _game.moveRight();
    notifyListeners();
  }
}
