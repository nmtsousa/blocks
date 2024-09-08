enum State { running, gameOver }

class Game {
  State state = State.running;
  String _boardState = "";
  Game.fromState(List<String> initialState) {
    assert(initialState.isNotEmpty);

    var rowLength = initialState[0].length;
    assert(rowLength > 0);

    for (int i = 1; i < initialState.length; i++) {
      assert(initialState[i].length == rowLength);
    }
    _boardState = '[${initialState.join("]\n[")}]';
  }

  @override
  String toString() {
    return _boardState;
  }

  void tick() {
    state = State.gameOver;
  }
}
