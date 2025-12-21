import 'package:flutter/material.dart';
import '../models/match.dart';
import 'history_screen.dart';

class GameScreen extends StatefulWidget {
  final String player1;
  final String player2;

  const GameScreen({super.key, required this.player1, required this.player2});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> displayElement = ['', '', '', '', '', '', '', '', ''];
  bool xTurn = true; // Player 1 is X
  int p1Score = 0;
  int p2Score = 0;
  int filledBoxes = 0;
  static List<MatchRecord> history = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tic Tac Toe"),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryScreen(history: history))),
          )
        ],
      ),
      body: Column(
        children: [
          // Scoreboard
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(children: [Text(widget.player1), Text(p1Score.toString(), style: const TextStyle(fontSize: 20))]),
                Column(children: [Text(widget.player2), Text(p2Score.toString(), style: const TextStyle(fontSize: 20))]),
              ],
            ),
          ),
          Text(xTurn ? "Turn: ${widget.player1} (X)" : "Turn: ${widget.player2} (O)", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          
          // The Game Board (Reduced Size)
          Expanded(
            flex: 3,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: AspectRatio(
                  aspectRatio: 1, // Keeps the grid square
                  child: GridView.builder(
                    itemCount: 9,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () => _tapped(index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              displayElement[index],
                              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          
          // Reset Buttons
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: _clearBoard, child: const Text("Reset Board")),
                const SizedBox(width: 10),
                OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text("Change Players")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _tapped(int index) {
    setState(() {
      if (xTurn && displayElement[index] == '') {
        displayElement[index] = 'X';
        filledBoxes++;
      } else if (!xTurn && displayElement[index] == '') {
        displayElement[index] = 'O';
        filledBoxes++;
      }
      xTurn = !xTurn;
      _checkWinner();
    });
  }

  void _checkWinner() {
    // Basic Win Logic (Rows, Cols, Diagonals)
    var lines = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Cols
      [0, 4, 8], [2, 4, 6]             // Diagonals
    ];

    for (var line in lines) {
      if (displayElement[line[0]] != '' &&
          displayElement[line[0]] == displayElement[line[1]] &&
          displayElement[line[0]] == displayElement[line[2]]) {
        _showWinDialog(displayElement[line[0]] == 'X' ? widget.player1 : widget.player2);
        return;
      }
    }
    if (filledBoxes == 9) _showWinDialog("Draw");
  }

  void _showWinDialog(String winner) {
    if (winner != "Draw") {
      setState(() {
        winner == widget.player1 ? p1Score++ : p2Score++;
      });
    }
    
    // Add to history
    history.add(MatchRecord(
      winner: winner,
      player1: widget.player1,
      player2: widget.player2,
      timestamp: DateTime.now(),
    ));

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(winner == "Draw" ? "It's a Tie!" : "Winner: $winner"),
          actions: [
            TextButton(onPressed: () { _clearBoard(); Navigator.of(context).pop(); }, child: const Text("Play Again")),
          ],
        );
      },
    );
  }

  void _clearBoard() {
    setState(() {
      for (int i = 0; i < 9; i++) {
        displayElement[i] = '';
      }
      filledBoxes = 0;
    });
  }
}