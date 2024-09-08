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

    for (int i = 0; i < rowCount; i++) {
      var rowState = _boardState[i];
      if (piece != null && _pieceRow == i) {
        rowState = rowState.replaceRange(
            _pieceCol, _pieceCol + piece.colCount, piece.piece[0]);
      }
      stateStr += rowState;
      if ((i + 1) < rowCount) {
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
        if (!piceFitsInBoard(piece, _pieceRow + 1, _pieceCol)) {
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
    _pieceCol = ((colCount - nextPiece.colCount) / 2).round();

    if (!piceFitsInBoard(nextPiece, _pieceRow, _pieceCol)) {
      state = State.gameOver;
      _currentPiece = null;
    }

    _currentPiece = nextPiece;
  }

  void _landPiece(Piece piece) {
    for (int i = 0; i < piece.piece.length; i++) {
      _boardState[_pieceRow + i] = _boardState[_pieceRow + i]
          .replaceRange(_pieceCol, _pieceCol + piece.colCount, piece.piece[i]);
    }
  }

  bool piceFitsInBoard(Piece piece, int pieceRow, int pieceCol) {
    for (int row = 0; row < piece.rowCount; row++) {
      for (int col = 0; col < piece.colCount; col++) {
        if (_boardState[pieceRow + row][pieceCol + col] != " ") {
          return false;
        }
      }
    }
    return true;
  }
}
