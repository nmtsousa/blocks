# Blocks

In this project you will find the steps taken to develop a blocks puzzle, similar to Tetris. The project is being built in the open and I am documenting the major decisions in articles.

## Current State Of The Project

The project is a Flutter application. To run it:

```bash
flutter test && flutter run
```

It will run all tests and the application in a simulator of your choice.

I have also published the HTML version of the [game to itch.io](https://nunosousa.itch.io/block-puzzle). This allow you to play it in the browser.

<iframe frameborder="0" src="https://itch.io/embed-upload/11744413?color=333333" allowfullscreen="" width="640" height="500"><a href="https://nunosousa.itch.io/block-puzzle">Play Block Puzzle on itch.io</a></iframe>

## All Iterations

| Article                                                                                                        | GitHub tag                                                                               |
| -------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| [Major decisions](https://medium.com/@nuno.mt.sousa/block-puzzle-starting-the-project-26c7bee8cc48)            | [000_InitialProject](https://github.com/nmtsousa/blocks/tree/000_InitialProject)         |
| [Base Game Logic](https://medium.com/@nuno.mt.sousa/block-puzzle-base-game-logic-8280139e9528)                 | [001_BaseGameLogic](https://github.com/nmtsousa/blocks/tree/001_BaseGameLogic)           |
| [Almost Playable](https://medium.com/@nuno.mt.sousa/block-puzzle-almost-playable-4398f723dedc)                 | [002_AlmostPlayable](https://github.com/nmtsousa/blocks/releases/tag/002_AlmostPlayable) |
| [We can play it!](https://medium.com/@nuno.mt.sousa/block-puzzle-we-can-play-it-8b770e4f0776)                  | [003_WeCanPlayIt](https://github.com/nmtsousa/blocks/releases/tag/003_WeCanPlayIt)       |
| [Color, Scores and Sound!](https://medium.com/@nuno.mt.sousa/block-puzzle-color-scores-and-sound-a3ec4dc14929) | [004_ColorsAndScores](https://github.com/nmtsousa/blocks/tree/004_ColorsAndScores)       |

## Sounds

I got the music and sounds out of [Pixabay](https://pixabay.com).

| Sounds                                                                           | Description                                                            |
| -------------------------------------------------------------------------------- | ---------------------------------------------------------------------- |
| [Clicks](https://pixabay.com/sound-effects/video-game-menu-click-sounds-148373/) | Video Game Menu Click Sounds, that I split to make the actions sounds. |
| [Start Sound](https://pixabay.com/sound-effects/button-124476/)                  | Sound for the game start button                                        |
| [Scoring](https://pixabay.com/sound-effects/collect-5930/)                       | When lines are completed                                               |
| [Game Over](https://pixabay.com/sound-effects/game-over-38511/)                  | Game over sound                                                        |
| [Background](https://pixabay.com/music/upbeat-ninja-247546/)                     | Background music                                                       |