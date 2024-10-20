import 'package:blocks/piece.dart';

enum GameState { running, gameOver }

final class BoardState {
  final List<String> rows;

  int get colCount => rows[0].length;
  int get rowCount => rows.length;

  BoardState({required this.rows});
}

class Game {
  final Iterable<Piece> _pieceProvider;
  late Piece _currentPiece;
  int _pieceRow = 0;
  int _pieceCol = 0;
  GameState _state = GameState.running;
  late List<String> _boardState;
  late final int _colCount;
  late final int _rowCount;

  Game.fromState(this._pieceProvider, List<String> initialState) {
    assert(initialState.isNotEmpty);

    _colCount = initialState[0].length;
    assert(_colCount > 0);

    for (int i = 1; i < initialState.length; i++) {
      assert(initialState[i].length == _colCount);
    }
    _boardState = initialState;
    _rowCount = _boardState.length;

    _placeNewPiece();
  }

  Game.empty(this._pieceProvider, this._colCount, this._rowCount) {
    _boardState = List.filled(_rowCount, _spaces(_colCount));
    _placeNewPiece();
  }

  String _spaces(n) => List.filled(n, ' ').join();

  GameState getState() {
    return _state;
  }

  BoardState getBoardState() {
    List<String> rows = List.empty(growable: true);

    for (int row = 0; row < _rowCount; row++) {
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

  int tick() {
    var removedLines = 0;
    var shouldLand = false;

    if (_pieceRow + _currentPiece.getRowCount() >= _rowCount) {
      shouldLand = true;
    } else {
      if (!_pieceFitsInBoard(_currentPiece, _pieceRow + 1, _pieceCol)) {
        shouldLand = true;
      }
    }
    if (shouldLand) {
      _landPiece(_currentPiece);
      removedLines = _removeCompletedLines();
      _placeNewPiece();
    } else {
      _pieceRow++;
    }
    return removedLines;
  }

  void _placeNewPiece() {
    _currentPiece = _pieceProvider.take(1).first;

    _pieceRow = 0;
    _pieceCol = ((_colCount - _currentPiece.getColCount()) / 2).truncate();

    if (!_pieceFitsInBoard(_currentPiece, _pieceRow, _pieceCol)) {
      _state = GameState.gameOver;
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

  int _removeCompletedLines() {
    List<int> completedRows = [];
    for (int row = 0; row < _rowCount; row++) {
      bool rowIsComplete = true;
      for (int col = 0; col < _colCount; col++) {
        var pixel = _boardState[row].substring(col, col + 1);
        if (pixel == ' ') {
          rowIsComplete = false;
          break;
        }
      }

      if (rowIsComplete) {
        completedRows.add(row);
      }
    }

    for (var rowToRemove in completedRows) {
      for (int row = rowToRemove; row > 0; row--) {
        _boardState[row] = _boardState[row - 1];
      }
      _boardState[0] = _spaces(_colCount);
    }

    return completedRows.length;
  }

  bool _pieceFitsInBoard(Piece piece, int pieceRow, int pieceCol) {
    for (int row = 0; row < piece.getRowCount(); row++) {
      if (pieceRow + row >= _rowCount) {
        return false;
      }

      for (int col = 0; col < piece.getColCount(); col++) {
        if (pieceCol + col >= _colCount) {
          return false;
        }

        if (piece.getPixel(row, col) != ' ' &&
            (pieceCol + col < 0 ||
                _boardState[pieceRow + row][pieceCol + col] != ' ')) {
          return false;
        }
      }
    }
    return true;
  }

  void moveLeft() {
    if (_state == GameState.gameOver) {
      return;
    }

    _pieceCol--;
    if (!_pieceFitsInBoard(_currentPiece, _pieceRow, _pieceCol)) {
      _pieceCol++;
    }
  }

  void moveRight() {
    if (_state == GameState.gameOver) {
      return;
    }

    _pieceCol++;
    if (!_pieceFitsInBoard(_currentPiece, _pieceRow, _pieceCol)) {
      _pieceCol--;
    }
  }

  void rotatePiece() {
    if (_state == GameState.gameOver) {
      return;
    }

    _currentPiece.rotate(1);
    if (!_pieceFitsInBoard(_currentPiece, _pieceRow, _pieceCol)) {
      _currentPiece.rotate(-1);
    }
  }
}
