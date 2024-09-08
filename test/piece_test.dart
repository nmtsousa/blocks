import 'package:blocks/piece.dart';
import 'package:test/test.dart';

void main() {
  test('Sprites must have at least one row', () {
    expect(() => PieceSprite([]), throwsA(isA<AssertionError>()));
  });

  test('Sprites must have at least one col', () {
    expect(() => PieceSprite(['']), throwsA(isA<AssertionError>()));
  });

  test('All rows in sprites must have the same col count', () {
    expect(() => PieceSprite(['xx', '']), throwsA(isA<AssertionError>()));
  });

  test('Pieces start with first sprite', () {
    var piece = Piece([
      PieceSprite([
        'PPP',
        'P  ',
      ]),
      PieceSprite(
        [
          'PP',
          ' P',
          ' P',
        ],
      )
    ]);

    expect(piece.getColCount(), equals(3));
    expect(piece.getRowCount(), equals(2));
  });

  test('When piece is rotate, second sprite is used', () {
    var piece = Piece([
      PieceSprite([
        'PPP',
        'P  ',
      ]),
      PieceSprite(
        [
          'PP',
          ' P',
          ' P',
        ],
      )
    ]);

    piece.rotate(1);
    expect(piece.getColCount(), equals(2));
    expect(piece.getRowCount(), equals(3));
  });

  test(
      'When piece is rotated at the last sprite, piece changes to first sprite',
      () {
    var piece = Piece([
      PieceSprite([
        'PPP',
        'P  ',
      ]),
      PieceSprite(
        [
          'PP',
          ' P',
          ' P',
        ],
      )
    ]);

    piece.rotate(1);
    piece.rotate(1);

    expect(piece.getColCount(), equals(3));
    expect(piece.getRowCount(), equals(2));
  });

  test(
      'When piece is rotate back and is the first sprite, piece changes to last sprite',
      () {
    var piece = Piece([
      PieceSprite([
        'PPP',
        'P  ',
      ]),
      PieceSprite(
        [
          'PP',
          ' P',
          ' P',
        ],
      )
    ]);

    piece.rotate(-1);

    expect(piece.getColCount(), equals(2));
    expect(piece.getRowCount(), equals(3));
  });
}
