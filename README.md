#Command Line Tic-Tac-Toe

This game of Tic-Tac-Toe is either single or multiplayer, depending on user specifications. If there is only one player, the opponent is a computer, whose AI I designed to be unbeatable. You can try to beat it all you want, but it is futile.

##How To Play
```bash
$ ./bin/tic_tac_toe -m [single, multiplayer]
```

Other options are prompted during game play.

##Unbeatable AI strategy
The AI iterates through a hierarchy of moves, starting with the one at the top. If that type of move exists, it plays that. Otherwise, if checks if the next type of move is possible, and so on.

1. __Win__: If the computer player can make three in a row, it does.
2. __Block__: If the opponent has two in a row, the computer blocks the opponent by placing its mark in the row.
3. __Fork__: Creates two threats to win, or two rows with two marks in each row.
4. __Block Opponent's Fork__: Places mark in a spot that blocks the opponent from creating a fork. This is actually the most difficult part of the AI to implement, as you must look ahead as to whether your block leaves another opportunity for the opponent to create a fork.
5. __Center__: If the center is open, move there.
  i. As a side note, if a player is making the first move, there are actually more opportunities for the player to win if his or her first move is on a corner instead of the center. However, since I am only concerned with creating an unbeatable and not untieable player, moving in the center first always is fine.
6. __Opposite Corner__: If an opponent's mark is in a corner, place mark in opposite corner.
7. __Open Corner__: Put a mark in a open corner.
8. __Open Side__: Put a mark in an open side (the middle square of any of the four sides).

