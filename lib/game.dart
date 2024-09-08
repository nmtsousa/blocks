enum State { running, gameOver }

class Piece {
  List<String> _piece;
  late int rowCount;
  late int colCount;

  Piece(this._piece) {
    rowCount = _piece.length;
    colCount = _piece[0].length;
  }
}

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
            _pieceCol, _pieceCol + piece.colCount, piece._piece[0]);
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
    if (_boardState[0].substring(0, 1) != ' ') {
      state = State.gameOver;
    }

    var piece = _currentPiece;
    if (piece == null) {
      _placeNewPiece();
    } else {
      var shouldLand = false;
      if (_pieceRow + piece.rowCount >= rowCount) {
        shouldLand = true;
      } else {
        outer:
        for (int row = 0; row < piece.rowCount; row++) {
          for (int col = 0; col < piece.colCount; col++) {
            if (_boardState[_pieceRow + row + 1][_pieceCol + col] != " ") {
              shouldLand = true;
              break outer;
            }
          }
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
    _currentPiece = nextPiece;
  }

  void _landPiece(Piece piece) {
    for (int i = 0; i < piece._piece.length; i++) {
      _boardState[_pieceRow + i] = _boardState[_pieceRow + i]
          .replaceRange(_pieceCol, _pieceCol + piece.colCount, piece._piece[i]);
    }
  }
}
