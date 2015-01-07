#Command Line Tic-Tac-Toe

This game of Tic-Tac-Toe is either single or multiplayer, depending on user specifications. If there is only one player, the opponent is a computer, whose AI I designed to be unbeatable. You can try to beat it all you want, but it is futile.

##How To Play
First, clone this repository by running the following in your command line.
```bash
$ git clone git@github.com:catarak/tic-tac-toe.git
```
Then, move into that directory:
```bash
$ cd tic-tac-toe
```
Then, to play the game: 
```bash
$ ./bin/tic_tac_toe -m [single, multiplayer]
```
Other options are prompted during game play


##Unbeatable AI strategy
The AI uses Alpha-beta pruning, a more efficient form of Minimax. You can read more about how it works on [a blog post I wrote](http://catarak.github.io/blog/2015/01/07/solving-tic-tac-toe/).

