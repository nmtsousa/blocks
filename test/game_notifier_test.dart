import 'package:blocks/game.dart';
import 'package:blocks/game_notifier.dart';
import 'package:test/test.dart';

void main() {
  test('Game is ticked when notifier receives a tick.', () {
    var mockGame = MockGame();
    GameNotifier notifier = GameNotifier.fromGame(mockGame);

    notifier.tick();

    assert(mockGame.tickCount == 1);
  });

  test('Listeners are notified when the game is ticked.', () {
    var mockGame = MockGame();
    GameNotifier notifier = GameNotifier.fromGame(mockGame);

    var notifications = [];
    notifier.addListener(() {
      notifications.add("1");
    });

    notifier.tick();

    assert(notifications.length == 1);
  });
}

class MockGame implements Game {
  var tickCount = 0;

  @override
  void tick() {
    tickCount++;
  }

  @override
  BoardState getBoardState() {
    assert(false);
    return BoardState(rows: []);
  }

  @override
  GameState getState() {
    assert(false);
    return GameState.gameOver;
  }

  @override
  void moveLeft() {
    assert(false);
  }

  @override
  void moveRight() {
    assert(false);
  }

  @override
  void rotatePiece() {
    assert(false);
  }
}
