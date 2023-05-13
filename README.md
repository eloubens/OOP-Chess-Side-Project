# OOP-Chess-Project
An interactive object oriented chess board game written in Java, utilizing Processing language libraries. 
Includes castling, prohibition of moves (e.g., not active player, illegal moves, castling conditions not being met), pawn promotion, and UI design (legal moves light up once figure is selected, active player is displayed on screen)

Guide:
This project will allow 2 players to play chess against one another. Players will take turns moving their chess pieces by clicking on them with their mouse. After the player has clicked where he/she wants the piece to move, that will be the piece’s final position. There is no undo move feature.


2 Player Game:
Once the program starts running, a chessboard will appear with all the black pieces on the top of the board and all of the white pieces on the bottom of the board. The pieces will always be black and white, and there are no options to change the colour of the pieces. The board will be numbered vertically from 1 to 8, and have letters from A to H horizontally. Text will also appear at the top left corner of the board informing which color’s turn it is, and this text changes from WHITE to BLACK as players move their pieces. The program does not ask which color the player wishes to be, the players discuss this information prior to the game. If a piece whose turn it is, is clicked, the cells where it can move become light green, and the tile it occupies becomes light blue. When a piece is captured it disappears. If a pawn reaches the opposite side of the board the player will be given the option of upgrading it to a knight, bishop, rook, or queen. The castling move can be executed- but under some certain conditions.

Piece Movements:
Pawn - Can move 1 square forward if there are no pieces there, or 2 if it is in starting position. It can capture pieces diagonal to it. 
Bishop - Can move an unlimited amount of squares, but it can only move diagonally. It can capture pieces of opposite colour in any direction as long as it moves diagonally.
Knight - Can move in an L-shape movement. It can move two squares horizontally and one square vertically, or two squares vertically and one square horizontally. It also has the ability to ‘jump’ over other pieces. It can capture pieces where it lands after executing the L-shape movement.
Rook - Can move an unlimited amount of squares in the horizontal or vertical direction. It can capture pieces as long as it moves in the horizontal or vertical direction.
Queen - Can move an unlimited amount of squares in the diagonal, horizontal, or vertical direction. It can capture pieces as long as it moves diagonally, horizontally, or vertically.
King - Can move 1 square in the diagonal, horizontal, or vertical direction. It can capture pieces as long as it moves 1 square diagonally, horizontally, or vertically. 

Special Moves:
Castling - Castling consists of moving the king two squares towards a rook, then placing the rook on the other side of the king, adjacent to it. The game will only allow castling when the king or rook have not previously moved or been castled and there must be no pieces in between the king and the rook.

Pawn Promotion - If a player advances a pawn to the end of the opposite side of the board, the pawn is then promoted (converted) to a queen, rook, bishop, or knight of the same color at the choice of the player. As soon as the player clicks on a particular cell that’s highlighted turquoise, the pawn will convert the pawn to a figure in said cell. The choice is not limited to previously captured pieces. 

Differences Between Regular Chess And The Program:
The program will not allow for the En Passant move to be executed.
The program will allow castling even when the king is in check or any cells in between the king and rook are attacked
The program will not recognize when the king is in check and will not prevent the user from moving certain pieces and will not force the user to get the king to safety
The program will not recognize a checkmate or stalemate and will allow for the game to continue; no message will be displayed as well.
The program will allow the king to take pieces, even if taking said piece will cause for the king to be in check
The program will not be able to recognize that moving one of its own pieces will cause for the king to be in check, and it will allow for said piece to be moved. 

*.pde linguist-language=Java
