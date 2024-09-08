enum State { running, gameOver }

class Piece {
  List<String> _piece;

  Piece(this._piece);
}

class Game {
  final Iterable<Piece> _pieceProvider;
  Piece? _currentPiece;
  int _pieceRow = 0;
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
        rowState =
            rowState.replaceRange(0, piece._piece[0].length, piece._piece[0]);
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

    if (_currentPiece == null) {
      _pieceRow = 0;
      _currentPiece = _pieceProvider.take(1).first;
    } else {
      _pieceRow++;
    }
  }
}
