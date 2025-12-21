import 'package:flutter/material.dart';
import 'game_screen.dart';

class PlayerEntryScreen extends StatefulWidget {
  const PlayerEntryScreen({super.key});

  @override
  State<PlayerEntryScreen> createState() => _PlayerEntryScreenState();
}

class _PlayerEntryScreenState extends State<PlayerEntryScreen> {
  final TextEditingController p1Controller = TextEditingController();
  final TextEditingController p2Controller = TextEditingController();

  void startGame() {
    if (p1Controller.text.isNotEmpty && p2Controller.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameScreen(
            player1: p1Controller.text,
            player2: p2Controller.text,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enter Players")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(controller: p1Controller, decoration: const InputDecoration(labelText: "Player 1 (X)")),
            TextField(controller: p2Controller, decoration: const InputDecoration(labelText: "Player 2 (O)")),
            const SizedBox(height: 30),
            ElevatedButton(onPressed: startGame, child: const Text("Start Game")),
          ],
        ),
      ),
    );
  }
}