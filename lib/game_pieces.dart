import 'dart:math';

import 'package:blocks/piece.dart';

Iterable<Piece> createGamePieceProvider() sync* {
  var rng = Random();
  while (true) {
    switch (rng.nextInt(7)) {
      case 0:
        yield Piece([
          PieceSprite([
            'PP',
            'PP',
          ])
        ]);
        break;
      case 1:
        yield Piece([
          PieceSprite([
            'PPP',
            'P  ',
          ]),
          PieceSprite([
            'PP',
            ' P',
            ' P',
          ]),
          PieceSprite([
            '  P',
            'PPP',
          ]),
          PieceSprite([
            'P ',
            'P ',
            'PP',
          ]),
        ]);
        break;
      case 2:
        yield Piece([
          PieceSprite([
            'P  ',
            'PPP',
          ]),
          PieceSprite([
            'PP',
            'P ',
            'P ',
          ]),
          PieceSprite([
            'PPP',
            '  P',
          ]),
          PieceSprite([
            ' P',
            ' P',
            'PP',
          ]),
        ]);
        break;
      case 3:
        yield Piece([
          PieceSprite([
            'PP ',
            ' PP',
          ]),
          PieceSprite([
            ' P',
            'PP',
            'P ',
          ]),
        ]);
        break;
      case 4:
        yield Piece([
          PieceSprite([
            ' PP',
            'PP ',
          ]),
          PieceSprite([
            'P ',
            'PP',
            ' P',
          ]),
        ]);
        break;
      case 5:
        yield Piece([
          PieceSprite([
            'PPPP',
          ]),
          PieceSprite([
            'P',
            'P',
            'P',
            'P',
          ]),
        ]);
        break;
      case 6:
        yield Piece([
          PieceSprite([
            'PPP',
            ' P ',
          ]),
          PieceSprite([
            ' P',
            'PP',
            ' P',
          ]),
          PieceSprite([
            ' P ',
            'PPP',
          ]),
          PieceSprite([
            'P ',
            'PP',
            'P ',
          ]),
        ]);
        break;
    }
  }
}
