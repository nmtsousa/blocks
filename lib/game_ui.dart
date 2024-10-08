import 'package:blocks/game_notifier.dart';
import 'package:flutter/material.dart';

class GameUI extends StatelessWidget {
  final GameNotifier _gameStateNotifier;

  const GameUI(this._gameStateNotifier, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _gameStateNotifier,
      builder: (context, child) {
        var boardState = _gameStateNotifier.boardState;
        var colCount = boardState.colCount;
        var rowCount = boardState.rowCount;

        List<Widget> rowList = [];
        for (int row = 0; row < rowCount; row++) {
          List<Widget> rowPixels = [];
          for (int col = 0; col < colCount; col++) {
            var pixelType = boardState.rows[row][col];
            Color pixelColor = switch (pixelType) {
              'A' => Colors.red,
              'B' => Colors.blue,
              'C' => Colors.green,
              'D' => Colors.orange,
              'E' => Colors.purple,
              'F' => Colors.pink,
              'G' => Colors.lime,
              ' ' => Colors.grey[900]!,
              _ => Colors.white,
            };

            rowPixels.add(Flexible(
              child: _Pixel(color: pixelColor),
            ));
          }
          rowList.add(Flexible(
            child: Row(children: rowPixels),
          ));
        }

        return Center(
          child: AspectRatio(
            aspectRatio: colCount / rowCount,
            child: Column(
              children: rowList,
            ),
          ),
        );
      },
    );
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
