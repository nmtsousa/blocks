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

    verifyGameState(game, [
      '   ',
      ' X ',
    ]);
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
    verifyGameState(game, [
      'P',
    ]);
  });

  test('Piece moves down when time ticks', () {
    var game = buildGame([
      ' ',
      ' ',
    ]);

    game.tick();
    game.tick();

    expect(game.state, equals(State.running));
    verifyGameState(game, [
      ' ',
      'P',
    ]);
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
    verifyGameState(game, [
      'P',
      'P',
    ]);
  });

  test('Pieces start in the middle of the board', () {
    var game = buildGame([
      '   ',
    ]);

    game.tick();
    verifyGameState(game, [
      ' P ',
    ]);
  });

  test('Pieces land if they hit something on the way down', () {
    var game = buildGame([
      '   ',
      ' X ',
    ]);

    game.tick();
    game.tick();
    verifyGameState(game, [
      ' P ',
      ' X ',
    ]);
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

    verifyGameState(game, [
      'PP ',
      ' P ',
    ]);
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

    verifyGameState(game, [
      'PP ',
      'XP ',
    ]);
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
    verifyGameState(game, [
      'PP ',
      ' P ',
      '   ',
      'X  ',
    ]);

    game.tick();
    verifyGameState(game, [
      '   ',
      'PP ',
      ' P ',
      'X  ',
    ]);

    game.tick();
    verifyGameState(game, [
      '   ',
      '   ',
      'PP ',
      'XP ',
    ]);

    game.tick();
    verifyGameState(game, [
      'PP ',
      ' P ',
      'PP ',
      'XP ',
    ]);

    game.tick();
    expect(game.state, State.gameOver);
  });

  test('It is possible to move pieces to the left', () {
    var game = buildGame([
      '   ',
    ]);

    game.tick();
    game.moveLeft();

    verifyGameState(game, [
      'P  ',
    ]);
  });

  test('You can not move to the left when you hit the board limit', () {
    var game = buildGame([
      '   ',
    ]);

    game.tick();
    game.moveLeft();
    game.moveLeft();

    verifyGameState(game, [
      'P  ',
    ]);
  });

  test('You can not move to the left if there is something in the way', () {
    var game = buildGame([
      'X  ',
    ]);

    game.tick();
    game.moveLeft();

    verifyGameState(game, [
      'XP ',
    ]);
  });

  test('You can move left with complex pieces', () {
    var game = buildGameWithPiece([
      'PP',
      ' P',
    ], [
      '    ',
      'X   ',
    ]);

    game.tick();
    game.moveLeft();

    verifyGameState(game, [
      'PP  ',
      'XP  ',
    ]);
  });

  test('You can not move left with complex pieces when they hit something', () {
    var game = buildGameWithPiece([
      'PP',
      'P ',
    ], [
      '    ',
      'X   ',
    ]);

    game.tick();
    game.moveLeft();

    verifyGameState(game, [
      ' PP ',
      'XP  ',
    ]);
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

void verifyGameState(Game game, List<String> expectedState) {
  expect(game.toString(), equalsGame(expectedState));
}

Matcher equalsGame(List<String> rows) {
  return equals('[${rows.join(']\n[')}]');
}
