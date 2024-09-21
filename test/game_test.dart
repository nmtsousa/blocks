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
      ' P ',
      ' X ',
    ]);
  });

  test('Games starts in the running state', () {
    var game = buildGame([' ']);
    expect(game.getState(), equals(GameState.running));
  });

  test('Game can be initialized by providing dimensions', () {
    var game = Game.empty(
        createPieceProvider(Piece([
          PieceSprite(['P'])
        ])),
        3,
        3);
    expect(game.getState(), equals(GameState.running));
    verifyGameState(game, [
      ' P ',
      '   ',
      '   ',
    ]);
  });

  test('Game is over when there is no space for the next piece', () {
    var game = buildGame([
      'X',
    ]);

    expect(game.getState(), equals(GameState.gameOver));
  });

  test('Piece enters board when there is space', () {
    var game = buildGame([
      ' ',
    ]);

    expect(game.getState(), equals(GameState.running));
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

    expect(game.getState(), equals(GameState.running));
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

    expect(game.getState(), equals(GameState.running));
    verifyGameState(game, [
      'P',
      'P',
    ]);
  });

  test('Pieces start in the middle of the board', () {
    var game = buildGame([
      '   ',
    ]);

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
    expect(game.getState(), equals(GameState.gameOver));
  });

  test('When large piece does not fit the board, game is over.', () {
    var game = buildGameWithSingleSpritePiece([
      'P',
      'P',
    ], [
      '   ',
    ]);

    expect(game.getState(), equals(GameState.gameOver));
  });

  test('Piece with holes can appear on board', () {
    var game = buildGameWithSingleSpritePiece([
      'PP',
      ' P',
    ], [
      '   ',
      '   ',
    ]);

    verifyGameState(game, [
      'PP ',
      ' P ',
    ]);
  });

  test('Piece with holes can appear on board', () {
    var game = buildGameWithSingleSpritePiece([
      'PP',
      ' P',
    ], [
      '   ',
      'X  ',
    ]);

    verifyGameState(game, [
      'PP ',
      'XP ',
    ]);
  });

  test('Complex piece lands in the middle of the board', () {
    var game = buildGameWithSingleSpritePiece([
      'PP',
      ' P',
    ], [
      '   ',
      '   ',
      '   ',
      'X  ',
    ]);

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
    expect(game.getState(), GameState.gameOver);
  });

  test('It is possible to move pieces to the left', () {
    var game = buildGame([
      '   ',
    ]);

    game.moveLeft();

    verifyGameState(game, [
      'P  ',
    ]);
  });

  test('You can not move to the left when you hit the board limit', () {
    var game = buildGame([
      '   ',
    ]);

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

    game.moveLeft();

    verifyGameState(game, [
      'XP ',
    ]);
  });

  test('You can move left with complex pieces', () {
    var game = buildGameWithSingleSpritePiece([
      'PP',
      ' P',
    ], [
      '    ',
      'X   ',
    ]);

    game.moveLeft();

    verifyGameState(game, [
      'PP  ',
      'XP  ',
    ]);
  });

  test('You can not move left with complex pieces when they hit something', () {
    var game = buildGameWithSingleSpritePiece([
      'PP',
      'P ',
    ], [
      '    ',
      'X   ',
    ]);

    game.moveLeft();

    verifyGameState(game, [
      ' PP ',
      'XP  ',
    ]);
  });

  test('It is possible to move pieces to the right', () {
    var game = buildGame([
      '   ',
    ]);

    game.moveRight();

    verifyGameState(game, [
      '  P',
    ]);
  });

  test('You can not move to the right when you hit the board limit', () {
    var game = buildGame([
      '   ',
    ]);

    game.moveRight();
    game.moveRight();

    verifyGameState(game, [
      '  P',
    ]);
  });

  test('You can not move to the right if there is something in the way', () {
    var game = buildGame([
      '  X',
    ]);

    game.moveRight();

    verifyGameState(game, [
      ' PX',
    ]);
  });

  test('You can move right with complex pieces', () {
    var game = buildGameWithSingleSpritePiece([
      'PP',
      ' P',
    ], [
      '    ',
      '   X',
    ]);

    game.moveRight();

    verifyGameState(game, [
      ' PP ',
      '  PX',
    ]);
  });

  test('You can move right with complex pieces ', () {
    var game = buildGameWithSingleSpritePiece([
      'PP',
      'P ',
    ], [
      '    ',
      '   X',
    ]);

    game.moveRight();

    verifyGameState(game, [
      '  PP',
      '  PX',
    ]);
  });

  test('You can not move right with complex pieces when they hit something',
      () {
    var game = buildGameWithSingleSpritePiece([
      'PP',
      ' P',
    ], [
      '    ',
      '   X',
    ]);

    game.moveRight();
    game.moveRight();

    verifyGameState(game, [
      ' PP ',
      '  PX',
    ]);
  });

  test('You can rotate pieces.', () {
    var game = buildGameWithPiece(
        Piece([
          PieceSprite([
            'PPP',
            'P  ',
          ]),
          PieceSprite([
            'PP',
            ' P',
            ' P',
          ])
        ]),
        [
          '    ',
          '    ',
          '    ',
        ]);

    game.rotatePiece();

    verifyGameState(game, [
      'PP  ',
      ' P  ',
      ' P  ',
    ]);
  });

  test('You can not rotate a piece if it passes the bottom of the board', () {
    var game = buildGameWithPiece(
        Piece([
          PieceSprite([
            'PPP',
            'P  ',
          ]),
          PieceSprite([
            'PP',
            ' P',
            ' P',
          ])
        ]),
        [
          '    ',
          '    ',
        ]);

    game.rotatePiece();

    verifyGameState(game, [
      'PPP ',
      'P   ',
    ]);
  });

  test('You can not rotate a piece if it will hit something', () {
    var game = buildGameWithPiece(
        Piece([
          PieceSprite([
            'PPP',
            'P  ',
          ]),
          PieceSprite([
            'PP',
            ' P',
            ' P',
          ])
        ]),
        [
          '    ',
          '    ',
          ' X  ',
        ]);

    game.rotatePiece();

    verifyGameState(game, [
      'PPP ',
      'P   ',
      ' X  ',
    ]);
  });

  test('You can not rotate a piece if it exceed the board width', () {
    var game = buildGameWithPiece(
        Piece([
          PieceSprite([
            'PP',
            ' P',
            ' P',
          ]),
          PieceSprite([
            'PPP',
            'P  ',
          ]),
        ]),
        [
          '   ',
          '   ',
          '   ',
        ]);

    game.moveRight();
    game.rotatePiece();

    verifyGameState(game, [
      ' PP',
      '  P',
      '  P',
    ]);
  });
}

Game buildGame(List<String> initialState) {
  return buildGameWithSingleSpritePiece(['P'], initialState);
}

buildGameWithSingleSpritePiece(List<String> piece, List<String> initialState) {
  return Game.fromState(
      createPieceProvider(Piece([PieceSprite(piece)])), initialState);
}

buildGameWithPiece(Piece piece, List<String> initialState) {
  return Game.fromState(createPieceProvider(piece), initialState);
}

Iterable<Piece> createPieceProvider(Piece piece) sync* {
  while (true) {
    yield piece;
  }
}

void verifyGameState(Game game, List<String> expectedState) {
  expect(gameStateToString(game), equalsGame(expectedState));
}

String gameStateToString(Game game) {
  var boardState = game.getBoardState();
  var rowCount = boardState.rows.length;

  var stateStr = '[';
  for (int row = 0; row < rowCount; row++) {
    stateStr += boardState.rows[row];
    if ((row + 1) < rowCount) {
      stateStr += ']\n[';
    }
  }
  stateStr += ']';

  return stateStr;
}

Matcher equalsGame(List<String> rows) {
  return equals('[${rows.join(']\n[')}]');
}
