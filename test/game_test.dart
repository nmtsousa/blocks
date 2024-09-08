import 'package:blocks/game.dart';
import 'package:test/test.dart';

void main() {
  test('Game fails to initialize if there are no lines in the board', () {
    expect(() => buildGame([]), throwsA(isA<AssertionError>()));
  });

  test('Game fails to initialize if there are no columns', () {
    expect(() => buildGame([""]), throwsA(isA<AssertionError>()));
  });

  test(
      'Game fails to initialize if the number of columns is not the same for all lines',
      () {
    expect(() => buildGame(["X", "XX"]), throwsA(isA<AssertionError>()));
  });

  test('Game can be initialized from state', () {
    var game = buildGame([
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
    var game = buildGame([' ']);
    expect(game.state, equals(State.running));
  });

  test('Game is over when there is no space for the next piece', () {
    var game = buildGame([
      'X',
    ]);

    game.tick();

    expect(game.state, equals(State.gameOver));
  });

  test('Piece enters board when there is space', () {
    var game = buildGame([
      ' ',
    ]);

    game.tick();

    expect(game.state, equals(State.running));
    expect(
        game.toString(),
        equalsGame([
          'P',
        ]));
  });
}

Iterable<Piece> pixelPieceProvider() sync* {
  while (true) {
    yield Piece(['P']);
  }
}

Game buildGame(List<String> initialState) {
  return Game.fromState(pixelPieceProvider(), initialState);
}

Matcher equalsGame(List<String> rows) {
  return equals('[${rows.join(']\n[')}]');
}
