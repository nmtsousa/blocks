import 'dart:math';

import 'package:blocks/piece.dart';

Iterable<Piece> createGamePieceProvider() sync* {
  var rng = Random();
  while (true) {
    switch (rng.nextInt(7)) {
      case 0:
        yield Piece([
          PieceSprite([
            'AA',
            'AA',
          ])
        ]);
        break;
      case 1:
        yield Piece([
          PieceSprite([
            'BBB',
            'B  ',
          ]),
          PieceSprite([
            'BB',
            ' B',
            ' B',
          ]),
          PieceSprite([
            '  B',
            'BBB',
          ]),
          PieceSprite([
            'B ',
            'B ',
            'BB',
          ]),
        ]);
        break;
      case 2:
        yield Piece([
          PieceSprite([
            'C  ',
            'CCC',
          ]),
          PieceSprite([
            'CC',
            'C ',
            'C ',
          ]),
          PieceSprite([
            'CCC',
            '  C',
          ]),
          PieceSprite([
            ' C',
            ' C',
            'CC',
          ]),
        ]);
        break;
      case 3:
        yield Piece([
          PieceSprite([
            'DD ',
            ' DD',
          ]),
          PieceSprite([
            ' D',
            'DD',
            'D ',
          ]),
        ]);
        break;
      case 4:
        yield Piece([
          PieceSprite([
            ' EE',
            'EE ',
          ]),
          PieceSprite([
            'E ',
            'EE',
            ' E',
          ]),
        ]);
        break;
      case 5:
        yield Piece([
          PieceSprite([
            'FFFF',
          ]),
          PieceSprite([
            ' F',
            ' F',
            ' F',
            ' F',
          ]),
        ]);
        break;
      case 6:
        yield Piece([
          PieceSprite([
            'GGG',
            ' G ',
          ]),
          PieceSprite([
            ' G',
            'GG',
            ' G',
          ]),
          PieceSprite([
            ' G ',
            'GGG',
          ]),
          PieceSprite([
            'G ',
            'GG',
            'G ',
          ]),
        ]);
        break;
    }
  }
}
