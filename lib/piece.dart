class PieceSprite {
  final List<String> piece;
  late int rowCount;
  late int colCount;

  PieceSprite(this.piece) {
    rowCount = piece.length;
    assert(rowCount > 0);

    colCount = piece[0].length;
    assert(colCount > 0);

    for (final row in piece) {
      assert(row.length == colCount);
    }
  }

  String _getPixel(int row, int col) {
    return piece[row].substring(col, col + 1);
  }
}

class Piece {
  final List<PieceSprite> sprites;
  int _currentSprite = 0;

  Piece(this.sprites);

  String getPixel(int row, int col) {
    return _getCurrentSprite()._getPixel(row, col);
  }

  PieceSprite _getCurrentSprite() => sprites[_currentSprite];

  int getRowCount() => _getCurrentSprite().rowCount;

  int getColCount() => _getCurrentSprite().colCount;

  void rotate() {
    _currentSprite++;
    if (_currentSprite >= sprites.length) {
      _currentSprite = 0;
    }
  }
}
