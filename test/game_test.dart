import 'package:blocks/game.dart';
import 'package:test/test.dart';

void main() {
  test('Game fails to initialize if there are no lines in the board', () {
    expect(() => Game.fromState([]), throwsA(isA<AssertionError>()));
  });

  test('Game fails to initialize if there are no columns', () {
    expect(() => Game.fromState([""]), throwsA(isA<AssertionError>()));
  });

  test(
      'Game fails to initialize if the number of columns is not the same for all lines',
      () {
    expect(() => Game.fromState(["X", "XX"]), throwsA(isA<AssertionError>()));
  });

  test('Game can be initialized from state', () {
    var game = Game.fromState([
      '   ',
      ' X ',
    ]);

    expect(
        game.toString(),
        equalsGame([
          '   ',
          ' X ',
        ]));
  });

  test('Games starts in the running state', () {
    var game = Game.fromState([' ']);
    expect(game.state, equals(State.running));
  });

  test('Game is over when there is no space for the next piece', () {
    var game = Game.fromState([
      'X',
    ]);

    game.tick();

    expect(game.state, equals(State.gameOver));
  });
}

equalsGame(List<String> rows) {
  return equals('[${rows.join(']\n[')}]');
}
