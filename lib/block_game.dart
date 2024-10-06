import 'dart:async';

import 'package:blocks/game.dart';
import 'package:blocks/game_notifier.dart';
import 'package:blocks/game_pieces.dart';
import 'package:blocks/game_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BlockGame extends StatefulWidget {
  const BlockGame({super.key});

  @override
  State<BlockGame> createState() => _BlockGameState();
}

enum _GameState { home, play, gameOver }

class _BlockGameState extends State<BlockGame> {
  _GameState _state = _GameState.home;
  GameNotifier _boardStateNotifier = GameNotifier(createGamePieceProvider());

  _BlockGameState() {
    ServicesBinding.instance.keyboard.addHandler(
      (event) {
        if (event is KeyDownEvent) {
          switch (event.logicalKey) {
            case LogicalKeyboardKey.arrowLeft:
              _boardStateNotifier.moveLeft();
              break;
            case LogicalKeyboardKey.arrowRight:
              _boardStateNotifier.moveRight();
              break;
            case LogicalKeyboardKey.arrowUp:
              _boardStateNotifier.rotate();
              break;
            case LogicalKeyboardKey.arrowDown:
              _boardStateNotifier.tick();
              break;
          }
        }
        return false;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.dark,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Block Puzzle'),
          ),
          body: switch (_state) {
            _GameState.home => _buildMenu(),
            _GameState.play => _buildGame(),
            _GameState.gameOver => _buildGameOver(),
          },
          bottomNavigationBar: switch (_state) {
            _GameState.home => null,
            _GameState.play || _GameState.gameOver => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: () => _boardStateNotifier.moveLeft(),
                      icon: const Icon(
                        Icons.arrow_left,
                        color: Colors.white,
                      )),
                  IconButton(
                      onPressed: () => _boardStateNotifier.rotate(),
                      icon: const Icon(
                        Icons.rotate_right,
                        color: Colors.white,
                      )),
                  IconButton(
                      onPressed: () => _boardStateNotifier.moveRight(),
                      icon: const Icon(
                        Icons.arrow_right,
                        color: Colors.white,
                      ))
                ],
              ),
          }),
      title: "Block Puzzle",
    );
  }

  Widget _buildGame() {
    return GameUI(_boardStateNotifier);
  }

  void showOverlay(BuildContext context) {
    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.3,
        left: MediaQuery.of(context).size.width * 0.2,
        child: Material(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.4,
            color: Colors.deepOrange,
            child: const Center(
              child: Text(
                'This is a pop-up dialog',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    // Remove overlay entry after a delay
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  Widget _buildMenu() {
    return Center(
      child: Column(
        children: [
          const Spacer(),
          TextButton(
            onPressed: () {
              _startNewGame();
            },
            child: const Text('New Game'),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  _buildGameOver() {
    return Center(
      child: Column(
        children: [
          const Spacer(),
          Title(
              color: Colors.white,
              child: const Text(
                'Game Over!',
                textScaler: TextScaler.linear(2),
              )),
          const Spacer(),
          TextButton(
            onPressed: () {
              _startNewGame();
            },
            child: const Text('New Game'),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  void _startNewGame() {
    setState(() {
      _boardStateNotifier = GameNotifier(createGamePieceProvider());
      _state = _GameState.play;
      Duration frameRate = const Duration(milliseconds: 300);
      Timer.periodic(frameRate, (timer) {
        _boardStateNotifier.tick();
        if (_boardStateNotifier.gameState == GameState.gameOver) {
          timer.cancel();
          setState(() {
            _state = _GameState.gameOver;
          });
        }
      });
    });
  }
}
