# Chess

A [FIDE Laws of Chess](http://www.fide.com/component/handbook/?id=171&view=article) compliant command-line Chess game.

## How to start

From the command list:
  * Enter `$ ruby lib/chess.rb` from the root directory
  
From the IRB:
  * Enter `$ load "lib/chess.rb"` from the root directory

The game should start once loaded.

## How to play

### Rules

This game implements the basic rules* of the [FIDE Laws of Chess](http://www.fide.com/component/handbook/?id=171&view=article). If you're not familiar with the rules of chess, [Wikipedia's summary](https://en.wikipedia.org/wiki/Rules_of_chess) of the topic is very approachable.

\* With one exception: the game doesn't ask to draw if an identical position has appeared three or more times.

### Pieces

Pieces are represented by their English [SAN](https://en.wikipedia.org/wiki/Algebraic_notation_(chess)) equivalents. White pieces are uppercase, black pieces are lowercase.

|  | King | Queen | Bishop | Rook | Knight | Pawn |
| --- | :---: | :---: | :---: | :---: | :---: | :---: |
| **White** | K | Q | B | R | N | P |
| **Black** | k | q | b | r | n | p |

### Moves

Squares are also represented by their corresponding algebraic notation. To move a piece, enter the notations for its current and destination squares. 

Example: `b2, b4`*

```
      a  b  c  d  e  f  g  h                  a  b  c  d  e  f  g  h

  8  [r][n][b][q][k][b][n][r]  8          8  [r][n][b][q][k][b][n][r]  8
  7  [p][p][p][p][p][p][p][p]  7          7  [p][p][p][p][p][p][p][p]  7
  6  [ ][ ][ ][ ][ ][ ][ ][ ]  6    \     6  [ ][ ][ ][ ][ ][ ][ ][ ]  6
  5  [ ][ ][ ][ ][ ][ ][ ][ ]  5     \    5  [ ][ ][ ][ ][ ][ ][ ][ ]  5
  4  [ ][ ][ ][ ][ ][ ][ ][ ]  4     /    4  [ ][P][ ][ ][ ][ ][ ][ ]  4
  3  [ ][ ][ ][ ][ ][ ][ ][ ]  3    /     3  [ ][ ][ ][ ][ ][ ][ ][ ]  3
  2  [P][P][P][P][P][P][P][P]  2          2  [P][ ][P][P][P][P][P][P]  2
  1  [R][N][B][Q][K][B][N][R]  1          1  [R][N][B][Q][K][B][N][R]  1
  
      a  b  c  d  e  f  g  h                  a  b  c  d  e  f  g  h
```

The format is the same for captures and special moves (eg. en passant and castling).

\* `b2, b4`, `b2,b4`, `b2 b4`, and `b2b4` are all valid and equivalent.

### Game Finish

The game ends automatically in the case of:
* [x] [Checkmate](https://en.wikipedia.org/wiki/Glossary_of_chess#Checkmate)
* [ ] [Stalemate](https://en.wikipedia.org/wiki/Glossary_of_chess#Stalemate)
* [ ] [Fifty-move rule](https://en.wikipedia.org/wiki/Glossary_of_chess#Fifty-move_rule)
* [ ] [Insufficient material](https://en.wikipedia.org/wiki/Glossary_of_chess#Insufficient_material)

The game otherwise ends in the case of:
* [ ] [Draw by agreement](https://en.wikipedia.org/wiki/Glossary_of_chess#Draw_by_agreement)
* [ ] [Resignation](https://en.wikipedia.org/wiki/Glossary_of_chess#Resign)
* [ ] ~~[Threefold repetition](https://en.wikipedia.org/wiki/Glossary_of_chess#Threefold_repetition)~~ (instead use "draw by agreement")

Only checkmate and resignation end with a victor.

### Commands

Before making a move, a player may invoke the following commands.

* `save` -- Saves the current game
* `load` -- Loads the previously saved game
* `quit` or `resign` -- Resigns from the game
* `draw` -- Draws the game

Note: Only `quit` / `resign` don't require the opponent's agreement.

## About

The first write was the product of test-driven development. This (more robust) verion was shaped through unit testing.

Written for [The Odin Project](http://www.theodinproject.com/). See **[Project: OOP with Ruby](http://www.theodinproject.com/ruby-programming/oop)** for more information.
