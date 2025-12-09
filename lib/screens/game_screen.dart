import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../models/match.dart';
import '../services/firebase_service.dart';
import 'player_entry_screen.dart';
import 'history_screen.dart';

class GameScreen extends StatefulWidget {
  final GameState gameState;

  const GameScreen({super.key, required this.gameState});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryScreen()),
              );
            },
            tooltip: 'Match History',
          ),
          IconButton(
            icon: const Icon(Icons.people),
            onPressed: _changePlayers,
            tooltip: 'Change Players',
          ),
        ],
      ),
      body: Column(
        children: [
          // Scoreboard
          _buildScoreboard(),
          
          const SizedBox(height: 20),
          
          // Current Turn Indicator
          _buildTurnIndicator(),
          
          const SizedBox(height: 20),
          
          // Game Board
          Expanded(
            child: _buildGameBoard(),
          ),
          
          const SizedBox(height: 20),
          
          // Reset Button
          _buildResetButton(),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Scoreboard Widget
  Widget _buildScoreboard() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _scoreCard(
            '${widget.gameState.player1Name} (X)',
            widget.gameState.xWins,
            Colors.blue,
          ),
          _scoreCard(
            'Ties',
            widget.gameState.ties,
            Colors.grey,
          ),
          _scoreCard(
            '${widget.gameState.player2Name} (O)',
            widget.gameState.oWins,
            Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _scoreCard(String label, int score, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          '$score',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  // Turn Indicator
  Widget _buildTurnIndicator() {
    if (widget.gameState.gameOver) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.green.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          widget.gameState.winner == 'Tie'
              ? "It's a Tie!"
              : '${widget.gameState.winner == 'X' ? widget.gameState.player1Name : widget.gameState.player2Name} Wins!',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: widget.gameState.currentPlayer == 'X'
            ? Colors.blue.shade100
            : Colors.red.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "${widget.gameState.currentPlayer == 'X' ? widget.gameState.player1Name : widget.gameState.player2Name}'s Turn (${widget.gameState.currentPlayer})",
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Game Board (3x3 Grid)
  Widget _buildGameBoard() {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        margin: const EdgeInsets.all(16),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: 9,
          itemBuilder: (context, index) {
            return _buildCell(index);
          },
        ),
      ),
    );
  }

  // Individual Cell
  Widget _buildCell(int index) {
    String cellValue = widget.gameState.board[index];
    
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.gameState.makeMove(index);
          
          // Save to Firebase when game ends
          if (widget.gameState.gameOver) {
            _saveMatchToFirebase();
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            cellValue,
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: cellValue == 'X' ? Colors.blue : Colors.red,
            ),
          ),
        ),
      ),
    );
  }

  // Reset Button
  Widget _buildResetButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          widget.gameState.resetGame();
        });
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      ),
      child: const Text(
        'New Game',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  // Save match to Firebase
  Future<void> _saveMatchToFirebase() async {
    try {
      final match = Match(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        winner: widget.gameState.winner,
        player1: widget.gameState.player1Name,
        player2: widget.gameState.player2Name,
        board: List<String>.from(widget.gameState.board),
        date: DateTime.now(),
      );

      await _firebaseService.saveMatch(match);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Match saved to history!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving match: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Change Players
  void _changePlayers() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Players'),
        content: const Text('This will reset all scores. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              widget.gameState.resetAll();
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => PlayerEntryScreen(
                    gameState: widget.gameState,
                  ),
                ),
              );
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}