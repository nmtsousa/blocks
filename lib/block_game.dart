import 'dart:async';

import 'package:blocks/game.dart';
import 'package:blocks/game_notifier.dart';
import 'package:blocks/game_pieces.dart';
import 'package:blocks/game_ui.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BlockGame extends StatefulWidget {
  const BlockGame({super.key});

  @override
  State<BlockGame> createState() => _BlockGameState();
}

enum _GameState { home, play, pause, gameOver }

class _BlockGameState extends State<BlockGame> with WidgetsBindingObserver {
  _GameState _state = _GameState.home;
  GameNotifier _boardStateNotifier = GameNotifier(createGamePieceProvider());
  int _score = 0;
  int _timeInterval = 600;
  Timer? _timer;
  bool _bgMusic = true;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      switch (state) {
        case AppLifecycleState.detached:
        case AppLifecycleState.hidden:
        case AppLifecycleState.inactive:
        case AppLifecycleState.paused:
          if (_state == _GameState.play) {
            _state = _GameState.pause;
            _stopTimer();
          }
          break;
        case AppLifecycleState.resumed:
        default:
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ServicesBinding.instance.keyboard.addHandler(_keyboardHandler);
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        _loadMusic();
      },
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();

    _stopBGMusic();

    ServicesBinding.instance.keyboard.removeHandler(_keyboardHandler);
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
            title: Row(children: [
              const Text('Block Puzzle'),
              const Spacer(),
              Text("$_score"),
              const Spacer(),
              IconButton(
                  onPressed: () => {
                        setState(() {
                          if (_bgMusic) {
                            _bgMusic = false;
                            _stopBGMusic();
                          } else {
                            _bgMusic = true;
                            if (_GameState == GameState.running) {
                              _startBGMusic();
                            }
                          }
                        })
                      },
                  icon: Icon(
                    _bgMusic ? Icons.music_note : Icons.music_off,
                    color: Colors.white,
                  )),
            ]),
          ),
          body: switch (_state) {
            _GameState.home => _buildMenu(),
            _GameState.play => _buildGame(),
            _GameState.pause => _buildPauseGame(),
            _GameState.gameOver => _buildGameOver(),
          },
          bottomNavigationBar: switch (_state) {
            _GameState.home => null,
            _GameState.play || _GameState.pause || _GameState.gameOver => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: () => _moveLeft(),
                      icon: const Icon(
                        Icons.arrow_left,
                        color: Colors.white,
                      )),
                  IconButton(
                      onPressed: () => _moveDown(),
                      icon: const Icon(
                        Icons.arrow_downward,
                        color: Colors.white,
                      )),
                  IconButton(
                      onPressed: () => _rotate(),
                      icon: const Icon(
                        Icons.rotate_right,
                        color: Colors.white,
                      )),
                  IconButton(
                      onPressed: () => _moveRight(),
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
              _playSound("button.mp3");
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
          Text("Your score: $_score"),
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

  _buildPauseGame() {
    return Center(
      child: Column(
        children: [
          const Spacer(),
          TextButton(
            onPressed: () {
              _playSound("button.mp3");
              setState(() {
                _state = _GameState.play;
                _startTimer();
              });
            },
            child: const Text('Resume Game'),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  void _startNewGame() {
    setState(() {
      _playSound("game-start.mp3");
      _boardStateNotifier = GameNotifier(createGamePieceProvider());
      _state = _GameState.play;
      _score = 0;
      _timeInterval = 500;
      _startTimer();
    });
  }

  void _startTimer() {
    _startBGMusic();
    Duration frameRate = Duration(milliseconds: _timeInterval);
    _timer = Timer.periodic(frameRate, (timer) {
      setState(() {
        _tickGame();
      });
    });
  }

  void _stopTimer() {
    _timer!.cancel();
    _stopBGMusic();
  }

  void _moveLeft() {
    _playSound("move.mp3");
    _boardStateNotifier.moveLeft();
  }

  void _moveRight() {
    _playSound("move.mp3");
    _boardStateNotifier.moveRight();
  }

  void _rotate() {
    _playSound("rotate.mp3");
    _boardStateNotifier.rotate();
  }

  void _moveDown() {
    _playSound("down.mp3");
    _tickGame();
  }

  void _tickGame() {
    var tickScore = _boardStateNotifier.tick();
    setState(() {
      _score += tickScore;
      if (_timeInterval > 300) {
        _timeInterval -= 5 * tickScore;
        _stopTimer();
        _startTimer();
      }
    });
    if (tickScore > 0) {
      _playSound("score.mp3");
    }
    if (_boardStateNotifier.gameState == GameState.gameOver) {
      _stopTimer();
      _state = _GameState.gameOver;
      _playSound("game-over.mp3");
    }
  }

  bool _keyboardHandler(KeyEvent event) {
    if (event is KeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.arrowLeft:
          _moveLeft();
          break;
        case LogicalKeyboardKey.arrowRight:
          _moveRight();
          break;
        case LogicalKeyboardKey.arrowUp:
          _rotate();
          break;
        case LogicalKeyboardKey.arrowDown:
          _moveDown();
          break;
      }
    }
    return false;
  }

  void _startBGMusic() {
    if (_bgMusic) {
      FlameAudio.bgm.play("background.mp3", volume: 0.2);
    }
  }

  void _stopBGMusic() {
    FlameAudio.bgm.stop();
  }

  void _loadMusic() async {
    FlameAudio.bgm.initialize();

    await FlameAudio.audioCache.load("background.mp3");
    await FlameAudio.audioCache.load("button.mp3");
    await FlameAudio.audioCache.load("down.mp3");
    await FlameAudio.audioCache.load("game-over.mp3");
    await FlameAudio.audioCache.load("game-start.mp3");
    await FlameAudio.audioCache.load("move.mp3");
    await FlameAudio.audioCache.load("rotate.mp3");
    await FlameAudio.audioCache.load("score.mp3");
  }

  void _playSound(String file) {
    FlameAudio.play(file).then(
      (value) {
        value.onPlayerComplete.listen(
          (event) {
            value.dispose();
          },
        );
      },
    );
  }
}
