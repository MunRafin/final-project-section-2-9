import 'package:flutter/foundation.dart';

class GameState extends ChangeNotifier {
  // Players
  String player1Name = 'Player 1';
  String player2Name = 'Player 2';
  
  // Game board (9 cells: 0-8)
  List<String> board = List.filled(9, ''); // ["", "", "", ...]
  
  // Current turn ('X' or 'O')
  String currentPlayer = 'X';
  
  // Game status
  bool gameOver = false;
  String winner = ''; // 'X', 'O', 'Tie', or ''
  
  // Scores
  int xWins = 0;
  int oWins = 0;
  int ties = 0;

  // Set player names (called from player entry screen)
  void setPlayerNames(String p1, String p2) {
    player1Name = p1;
    player2Name = p2;
    notifyListeners();
  }

  // Make a move on the board
  void makeMove(int index) {
    // Validate move
    if (gameOver || board[index] != '') return;
    
    // Place symbol
    board[index] = currentPlayer;
    
    // Check for winner or tie
    if (_checkWinner()) {
      gameOver = true;
      winner = currentPlayer;
      if (currentPlayer == 'X') {
        xWins++;
      } else {
        oWins++;
      }
    } else if (!board.contains('')) {
      // Board full = tie
      gameOver = true;
      winner = 'Tie';
      ties++;
    } else {
      // Switch player
      currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
    }
    
    notifyListeners();
  }

  // Check if current player won
  bool _checkWinner() {
    // Winning combinations (rows, columns, diagonals)
    const winPatterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
      [0, 4, 8], [2, 4, 6],            // Diagonals
    ];

    for (var pattern in winPatterns) {
      if (board[pattern[0]] == currentPlayer &&
          board[pattern[1]] == currentPlayer &&
          board[pattern[2]] == currentPlayer) {
        return true;
      }
    }
    return false;
  }

  // Reset board for new game
  void resetGame() {
    board = List.filled(9, '');
    currentPlayer = currentPlayer == 'X' ? 'O' : 'X'; // Switch starter
    gameOver = false;
    winner = '';
    notifyListeners();
  }

  // Reset everything (new players)
  void resetAll() {
    board = List.filled(9, '');
    currentPlayer = 'X';
    gameOver = false;
    winner = '';
    xWins = 0;
    oWins = 0;
    ties = 0;
    notifyListeners();
  }
}