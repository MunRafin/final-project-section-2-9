import 'package:flutter/material.dart';
import '../models/match.dart';

class HistoryScreen extends StatelessWidget {
  final List<MatchRecord> history;
  const HistoryScreen({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Match History")),
      body: history.isEmpty
          ? const Center(child: Text("No matches played yet."))
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final match = history[index];
                return ListTile(
                  title: Text("Winner: ${match.winner}"),
                  subtitle: Text("${match.player1} vs ${match.player2}"),
                  trailing: Text("${match.timestamp.hour}:${match.timestamp.minute}"),
                );
              },
            ),
    );
  }
}