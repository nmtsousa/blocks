enum State { running, gameOver }

class Piece {
  List<String> _piece;

  Piece(List<String> this._piece);
}

class Game {
  Iterable<Piece> _pieceProvider;
  State state = State.running;
  late List<String> _boardState;
  Game.fromState(this._pieceProvider, List<String> initialState) {
    assert(initialState.isNotEmpty);

    var rowLength = initialState[0].length;
    assert(rowLength > 0);

    for (int i = 1; i < initialState.length; i++) {
      assert(initialState[i].length == rowLength);
    }
    _boardState = initialState;
  }

  @override
  String toString() {
    return '[${_boardState.join("]\n[")}]';
  }

  void tick() {
    if (_boardState[0].substring(0, 1) != ' ') {
      state = State.gameOver;
    }

    Piece piece = _pieceProvider.take(1).first;
    _boardState[0] = piece._piece[0];
  }
}
