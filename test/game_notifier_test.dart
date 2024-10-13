import 'package:blocks/game.dart';
import 'package:blocks/game_notifier.dart';
import 'package:test/test.dart';

void main() {
  test('Game is ticked when notifier receives a tick and notifies listeners.',
      () {
    var mockGame = MockGame();
    GameNotifier notifier = GameNotifier.fromGame(mockGame);

    var notifications = [];
    notifier.addListener(() {
      notifications.add("1");
    });
    notifier.tick();

    assert(mockGame.tickCount == 1);
    assert(notifications.length == 1);
  });

  test(
      'When notifier is asked to move left, game is notified to move left and listeners are notified.',
      () {
    var mockGame = MockGame();
    GameNotifier notifier = GameNotifier.fromGame(mockGame);

    var notifications = [];
    notifier.addListener(() {
      notifications.add("1");
    });
    notifier.moveLeft();

    assert(mockGame.leftCount == 1);
    assert(notifications.length == 1);
  });

  test(
      'When notifier is asked to move right, game is notified to move right and listeners are notified.',
      () {
    var mockGame = MockGame();
    GameNotifier notifier = GameNotifier.fromGame(mockGame);

    var notifications = [];
    notifier.addListener(() {
      notifications.add("1");
    });
    notifier.moveRight();

    assert(mockGame.rightCount == 1);
    assert(notifications.length == 1);
  });

  test(
      'When notifier is asked to rotate, game is notified to rotate and listeners are notified.',
      () {
    var mockGame = MockGame();
    GameNotifier notifier = GameNotifier.fromGame(mockGame);

    var notifications = [];
    notifier.addListener(() {
      notifications.add("1");
    });
    notifier.rotate();

    assert(mockGame.rotateCount == 1);
    assert(notifications.length == 1);
  });
}

class MockGame implements Game {
  var tickCount = 0;
  var leftCount = 0;
  var rightCount = 0;
  var rotateCount = 0;

  @override
  int tick() {
    tickCount++;
    return 0;
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
    leftCount++;
  }

  @override
  void moveRight() {
    rightCount++;
  }

  @override
  void rotatePiece() {
    rotateCount++;
  }
}
