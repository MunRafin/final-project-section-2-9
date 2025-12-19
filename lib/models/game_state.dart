import 'package:flutter/foundation.dart';

class GameState extends ChangeNotifier {
  String player1Name = 'Player 1';
  String player2Name = 'Player 2';
  List<String> board = List.filled(9, '');
  String currentPlayer = 'X';
  bool gameOver = false;
  String winner = '';
  int xWins = 0;
  int oWins = 0;
  int ties = 0;

  void setPlayerNames(String p1, String p2) {
    player1Name = p1;
    player2Name = p2;
    notifyListeners();
  }

  void makeMove(int index) {
    // VALIDATION: Strict check to prevent logic running after game ends
    if (gameOver || board[index] != '') return;
    
    board[index] = currentPlayer;
    
    if (_checkWinner()) {
      gameOver = true;
      winner = currentPlayer;
      if (currentPlayer == 'X') {
        xWins++;
      } else {
        oWins++;
      }
    } else if (!board.contains('')) {
      gameOver = true;
      winner = 'Tie';
      ties++;
    } else {
      currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
    }
    
    notifyListeners();
  }

  bool _checkWinner() {
    const winPatterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6],
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

  void resetGame() {
    board = List.filled(9, '');
    currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
    gameOver = false;
    winner = '';
    notifyListeners();
  }

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