import 'package:flutter/material.dart';
import '../models/game_state.dart';
import 'game_screen.dart';

class PlayerEntryScreen extends StatefulWidget {
  final GameState gameState;

  const PlayerEntryScreen({super.key, required this.gameState});

  @override
  State<PlayerEntryScreen> createState() => _PlayerEntryScreenState();
}

class _PlayerEntryScreenState extends State<PlayerEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _player1Controller = TextEditingController();
  final _player2Controller = TextEditingController();

  @override
  void dispose() {
    _player1Controller.dispose();
    _player2Controller.dispose();
    super.dispose();
  }

  void _startGame() {
    if (_formKey.currentState!.validate()) {
      widget.gameState.setPlayerNames(
        _player1Controller.text,
        _player2Controller.text,
      );
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GameScreen(gameState: widget.gameState),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Enter Player Names',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              
              // Player 1 Input
              TextFormField(
                controller: _player1Controller,
                decoration: const InputDecoration(
                  labelText: 'Player 1 (X)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter Player 1 name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              // Player 2 Input
              TextFormField(
                controller: _player2Controller,
                decoration: const InputDecoration(
                  labelText: 'Player 2 (O)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter Player 2 name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              
              // Start Button
              ElevatedButton(
                onPressed: _startGame,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Start Game'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}