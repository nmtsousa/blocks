import 'package:blocks/main.dart';
import 'package:flutter/material.dart';

class GameUI extends StatelessWidget {
  final BoardStateNotifier _gameStateNotifier;

  GameUI(this._gameStateNotifier, {super.key});

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
