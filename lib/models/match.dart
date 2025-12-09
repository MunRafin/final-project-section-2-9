class Match {
  final String id;
  final String winner;        // "X", "O", or "Tie"
  final String player1;       // Player X name
  final String player2;       // Player O name
  final List<String> board;   // 9 elements: ["X", "O", "", ...]
  final DateTime date;

  Match({
    required this.id,
    required this.winner,
    required this.player1,
    required this.player2,
    required this.board,
    required this.date,
  });

  // Convert Match to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'winner': winner,
      'player1': player1,
      'player2': player2,
      'board': board,
      'date': date.toIso8601String(),
    };
  }

  // Create Match from Firebase Map
  factory Match.fromMap(String id, Object? map) {
    final Map<String, dynamic> m = (map is Map<String, dynamic>) ? map : {};
    return Match(
      id: id,
      winner: m['winner'] ?? '',
      player1: m['player1'] ?? '',
      player2: m['player2'] ?? '',
      board: List<String>.from(m['board'] ?? []),
      date: DateTime.tryParse(m['date'] ?? '') ?? DateTime.now(),
    );
  }
}