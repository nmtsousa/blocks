import 'dart:async';

import 'package:blocks/game.dart';
import 'package:blocks/piece.dart';
import 'package:flutter/material.dart';

class GameUI extends StatefulWidget {
  const GameUI({super.key});

  @override
  State<GameUI> createState() => _GameUIState();
}

class _GameUIState extends State<GameUI> {
  final Game _game = Game.empty(
      _createPieceProvider(Piece([
        PieceSprite(['P'])
      ])),
      10,
      15);

  @override
  Widget build(BuildContext context) {
    var boardState = _game.getBoardState();
    var colCount = boardState.colCount;
    var rowCount = boardState.rowCount;

    List<Widget> rowList = [];
    for (int row = 0; row < rowCount; row++) {
      List<Widget> rowPixels = [];
      for (int col = 0; col < colCount; col++) {
        Color pixelColor = Colors.grey[900]!;

        var pixelType = boardState.rows[row][col];
        if (pixelType != ' ') {
          pixelColor = Colors.white;
        }

        rowPixels.add(Flexible(
          child: _Pixel(color: pixelColor),
        ));
      }
      rowList.add(Flexible(
        child: Row(children: rowPixels),
      ));
    }

    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
      body: Center(
        child: AspectRatio(
          aspectRatio: colCount / rowCount,
          child: Column(
            children: rowList,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    startGame();
  }

  void startGame() {
    Duration frameRate = const Duration(milliseconds: 100);
    gameLoop(frameRate);
  }

  void gameLoop(Duration frameRate) {
    Timer.periodic(
      frameRate,
      (timer) {
        setState(() {
          _game.tick();
          if (_game.getState() == GameState.gameOver) {
            timer.cancel();
          }
        });
      },
    );
  }

  static Iterable<Piece> _createPieceProvider(Piece piece) sync* {
    while (true) {
      yield piece;
    }
  }
}

class _Pixel extends StatelessWidget {
  final Color color;

  const _Pixel({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      margin: const EdgeInsets.all(1),
    );
  }
}
