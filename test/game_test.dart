import 'package:blocks/game.dart';
import 'package:blocks/piece.dart';
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

  test('Piece moves down when time ticks', () {
    var game = buildGame([
      ' ',
      ' ',
    ]);

    game.tick();
    game.tick();

    expect(game.state, equals(State.running));
    expect(
        game.toString(),
        equalsGame([
          ' ',
          'P',
        ]));
  });

  test('Pieces land when they reach the last row', () {
    var game = buildGame([
      ' ',
      ' ',
    ]);

    game.tick();
    game.tick();
    game.tick();

    expect(game.state, equals(State.running));
    expect(
        game.toString(),
        equalsGame([
          'P',
          'P',
        ]));
  });

  test('Pieces start in the middle of the board', () {
    var game = buildGame([
      '   ',
    ]);

    game.tick();
    expect(
        game.toString(),
        equalsGame([
          ' P ',
        ]));
  });

  test('Pieces land if they hit something on the way down', () {
    var game = buildGame([
      '   ',
      ' X ',
    ]);

    game.tick();
    game.tick();
    expect(
        game.toString(),
        equalsGame([
          ' P ',
          ' X ',
        ]));
  });

  test(
      'Game ends if there is no space for next piece when the current one lands',
      () {
    var game = buildGame([
      '   ',
      ' X ',
    ]);

    game.tick();
    game.tick();
    expect(game.state, equals(State.gameOver));
  });

  test('When large piece does not fit the board, game is over.', () {
    var game = buildGameWithPiece([
      'P',
      'P',
    ], [
      '   ',
    ]);

    game.tick();
    expect(game.state, equals(State.gameOver));
  });

  test('Piece with holes can appear on board', () {
    var game = buildGameWithPiece([
      'PP',
      ' P',
    ], [
      '   ',
      '   ',
    ]);

    game.tick();

    expect(
        game.toString(),
        equalsGame([
          'PP ',
          ' P ',
        ]));
  });

  test('Piece with holes can appear on board', () {
    var game = buildGameWithPiece([
      'PP',
      ' P',
    ], [
      '   ',
      'X  ',
    ]);

    game.tick();

    expect(
        game.toString(),
        equalsGame([
          'PP ',
          'XP ',
        ]));
  });

  test('Complex piece lands in the middle of the board', () {
    var game = buildGameWithPiece([
      'PP',
      ' P',
    ], [
      '   ',
      '   ',
      '   ',
      'X  ',
    ]);

    game.tick();
    expect(
        game.toString(),
        equalsGame([
          'PP ',
          ' P ',
          '   ',
          'X  ',
        ]));

    game.tick();
    expect(
        game.toString(),
        equalsGame([
          '   ',
          'PP ',
          ' P ',
          'X  ',
        ]));

    game.tick();
    expect(
        game.toString(),
        equalsGame([
          '   ',
          '   ',
          'PP ',
          'XP ',
        ]));

    game.tick();
    expect(
        game.toString(),
        equalsGame([
          'PP ',
          ' P ',
          'PP ',
          'XP ',
        ]));

    game.tick();
    expect(game.state, State.gameOver);
  });
}

Iterable<Piece> createPieceProvider(List<String> piece) sync* {
  while (true) {
    yield Piece(piece);
  }
}

Game buildGame(List<String> initialState) {
  return Game.fromState(createPieceProvider(['P']), initialState);
}

buildGameWithPiece(List<String> piece, List<String> initialState) {
  return Game.fromState(createPieceProvider(piece), initialState);
}

Matcher equalsGame(List<String> rows) {
  return equals('[${rows.join(']\n[')}]');
}
