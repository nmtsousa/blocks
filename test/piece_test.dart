import 'package:blocks/piece.dart';
import 'package:test/test.dart';

void main() {
  test('Piece must have at least one row', () {
    expect(() => buildPiece([]), throwsA(isA<AssertionError>()));
  });

  test('Piece must have at least one col', () {
    expect(() => buildPiece(['']), throwsA(isA<AssertionError>()));
  });

  test('All rows must have the same col count', () {
    expect(() => buildPiece(['xx', '']), throwsA(isA<AssertionError>()));
  });
}

Piece buildPiece(List<String> piceShape) {
  return Piece(piceShape);
}
