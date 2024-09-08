class Piece {
  final List<String> piece;
  late int rowCount;
  late int colCount;

  Piece(this.piece) {
    rowCount = piece.length;
    assert(rowCount > 0);

    colCount = piece[0].length;
    assert(colCount > 0);

    for (final row in piece) {
      assert(row.length == colCount);
    }
  }
}
