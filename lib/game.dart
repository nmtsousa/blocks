import 'package:blocks/piece.dart';

enum State { running, gameOver }

class Game {
  final Iterable<Piece> _pieceProvider;
  Piece? _currentPiece;
  int _pieceRow = 0;
  int _pieceCol = 0;
  State state = State.running;
  late List<String> _boardState;
  late int colCount;
  late int rowCount;

  Game.fromState(this._pieceProvider, List<String> initialState) {
    assert(initialState.isNotEmpty);

    colCount = initialState[0].length;
    assert(colCount > 0);

    for (int i = 1; i < initialState.length; i++) {
      assert(initialState[i].length == colCount);
    }
    _boardState = initialState;
    rowCount = _boardState.length;
  }

  @override
  String toString() {
    var piece = _currentPiece;

    var stateStr = '[';

    for (int row = 0; row < rowCount; row++) {
      var rowState = _boardState[row];
      if (piece != null &&
          row >= _pieceRow &&
          row < _pieceRow + piece.rowCount) {
        for (int col = 0; col < piece.colCount; col++) {
          var pixel = piece.getPixel(row - _pieceRow, col);
          if (pixel != ' ') {
            rowState = rowState.replaceRange(
                _pieceCol + col, _pieceCol + col + 1, pixel);
          }
        }
      }
      stateStr += rowState;
      if ((row + 1) < rowCount) {
        stateStr += ']\n[';
      }
    }
    stateStr += ']';
    return stateStr;
  }

  void tick() {
    var piece = _currentPiece;
    if (piece == null) {
      _placeNewPiece();
    } else {
      var shouldLand = false;
      if (_pieceRow + piece.rowCount >= rowCount) {
        shouldLand = true;
      } else {
        if (!pieceFitsInBoard(piece, _pieceRow + 1, _pieceCol)) {
          shouldLand = true;
        }
      }
      if (shouldLand) {
        _landPiece(piece);
        _placeNewPiece();
      } else {
        _pieceRow++;
      }
    }
  }

  void _placeNewPiece() {
    var nextPiece = _pieceProvider.take(1).first;

    _pieceRow = 0;
    _pieceCol = ((colCount - nextPiece.colCount) / 2).truncate();

    if (!pieceFitsInBoard(nextPiece, _pieceRow, _pieceCol)) {
      state = State.gameOver;
      _currentPiece = null;
    }

    _currentPiece = nextPiece;
  }

  void _landPiece(Piece piece) {
    for (int row = 0; row < piece.rowCount; row++) {
      for (int col = 0; col < piece.colCount; col++) {
        var pixel = piece.getPixel(row, col);
        if (pixel != ' ') {
          _boardState[_pieceRow + row] = _boardState[_pieceRow + row]
              .replaceRange(_pieceCol + col, _pieceCol + col + 1, pixel);
        }
      }
    }
  }

  bool pieceFitsInBoard(Piece piece, int pieceRow, int pieceCol) {
    for (int row = 0; row < piece.rowCount; row++) {
      if (pieceRow + row >= rowCount) {
        return false;
      }

      for (int col = 0; col < piece.colCount; col++) {
        if (piece.getPixel(row, col) != ' ' &&
            _boardState[pieceRow + row][pieceCol + col] != ' ') {
          return false;
        }
      }
    }
    return true;
  }
}
