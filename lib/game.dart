import 'package:blocks/piece.dart';

enum State { running, gameOver }

final class BoardState {
  final List<String> rows;

  BoardState({required this.rows});
}

class Game {
  final Iterable<Piece> _pieceProvider;
  late Piece _currentPiece;
  int _pieceRow = 0;
  int _pieceCol = 0;
  State _state = State.running;
  late List<String> _boardState;
  late final int colCount;
  late final int rowCount;

  Game.fromState(this._pieceProvider, List<String> initialState) {
    assert(initialState.isNotEmpty);

    colCount = initialState[0].length;
    assert(colCount > 0);

    for (int i = 1; i < initialState.length; i++) {
      assert(initialState[i].length == colCount);
    }
    _boardState = initialState;
    rowCount = _boardState.length;

    _placeNewPiece();
  }

  State getState() {
    return _state;
  }

  BoardState getBoardState() {
    List<String> rows = List.empty(growable: true);

    for (int row = 0; row < rowCount; row++) {
      var rowState = _boardState[row];
      if (row >= _pieceRow && row < _pieceRow + _currentPiece.getRowCount()) {
        for (int col = 0; col < _currentPiece.getColCount(); col++) {
          var pixel = _currentPiece.getPixel(row - _pieceRow, col);
          if (pixel != ' ') {
            rowState = rowState.replaceRange(
                _pieceCol + col, _pieceCol + col + 1, pixel);
          }
        }
      }
      rows.add(rowState);
    }

    return BoardState(rows: rows);
  }

  void tick() {
    var shouldLand = false;
    if (_pieceRow + _currentPiece.getRowCount() >= rowCount) {
      shouldLand = true;
    } else {
      if (!_pieceFitsInBoard(_currentPiece, _pieceRow + 1, _pieceCol)) {
        shouldLand = true;
      }
    }
    if (shouldLand) {
      _landPiece(_currentPiece);
      _placeNewPiece();
    } else {
      _pieceRow++;
    }
  }

  void _placeNewPiece() {
    _currentPiece = _pieceProvider.take(1).first;

    _pieceRow = 0;
    _pieceCol = ((colCount - _currentPiece.getColCount()) / 2).truncate();

    if (!_pieceFitsInBoard(_currentPiece, _pieceRow, _pieceCol)) {
      _state = State.gameOver;
    }
  }

  void _landPiece(Piece piece) {
    for (int row = 0; row < piece.getRowCount(); row++) {
      for (int col = 0; col < piece.getColCount(); col++) {
        var pixel = piece.getPixel(row, col);
        if (pixel != ' ') {
          _boardState[_pieceRow + row] = _boardState[_pieceRow + row]
              .replaceRange(_pieceCol + col, _pieceCol + col + 1, pixel);
        }
      }
    }
  }

  bool _pieceFitsInBoard(Piece piece, int pieceRow, int pieceCol) {
    for (int row = 0; row < piece.getRowCount(); row++) {
      if (pieceRow + row >= rowCount) {
        return false;
      }

      for (int col = 0; col < piece.getColCount(); col++) {
        if (pieceCol + col >= colCount) {
          return false;
        }

        if (piece.getPixel(row, col) != ' ' &&
            _boardState[pieceRow + row][pieceCol + col] != ' ') {
          return false;
        }
      }
    }
    return true;
  }

  void moveLeft() {
    if (_pieceCol == 0) {
      return;
    } else {
      for (int row = 0; row < _currentPiece.getRowCount(); row++) {
        for (int col = 0; col < _currentPiece.getColCount(); col++) {
          if (_currentPiece.getPixel(row, col) == ' ') {
            continue;
          }

          if (_boardState[_pieceRow + row][_pieceCol + col - 1] != ' ') {
            return;
          }
        }
      }
      _pieceCol--;
    }
  }

  void moveRight() {
    if (_pieceCol == colCount - 1) {
      return;
    } else {
      for (int row = 0; row < _currentPiece.getRowCount(); row++) {
        for (int col = 0; col < _currentPiece.getColCount(); col++) {
          if (_currentPiece.getPixel(row, col) == ' ') {
            continue;
          }

          if (_boardState[_pieceRow + row][_pieceCol + col + 1] != ' ') {
            return;
          }
        }
      }

      _pieceCol++;
    }
  }

  void rotatePiece() {
    _currentPiece.rotate(1);
    if (!_pieceFitsInBoard(_currentPiece, _pieceRow, _pieceCol)) {
      _currentPiece.rotate(-1);
    }
  }
}
