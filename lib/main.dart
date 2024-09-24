import 'dart:async';

import 'package:blocks/game.dart';
import 'package:blocks/game_notifier.dart';
import 'package:blocks/game_ui.dart';
import 'package:flutter/material.dart';

void main() {
  GameNotifier boardStateNotifier = GameNotifier();

  runApp(MyApp(boardStateNotifier));

  Duration frameRate = const Duration(milliseconds: 100);
  Timer.periodic(frameRate, (timer) {
    boardStateNotifier.tick();
    if (boardStateNotifier.gameState == GameState.gameOver) {
      timer.cancel();
    }
  });
}

class MyApp extends StatelessWidget {
  final GameNotifier _boardStateNotifier;

  const MyApp(this._boardStateNotifier, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
      body: GameUI(_boardStateNotifier),
    ));
  }
}
