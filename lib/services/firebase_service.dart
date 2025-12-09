import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/match.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'matches';

  // Save match to Firebase
  Future<void> saveMatch(Match match) async {
    try {
      await _firestore.collection(_collectionName).add(match.toMap());
    } catch (e) {
      print('Error saving match: $e');
      rethrow;
    }
  }

  // Get all matches ordered by date (newest first)
  Future<List<Match>> getMatches() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collectionName)
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs.map((doc) {
          return Match.fromMap(doc.id, doc.data());
      }).toList();
    } catch (e) {
      print('Error getting matches: $e');
      return [];
    }
  }

  // Get matches as stream (real-time updates)
  Stream<List<Match>> getMatchesStream() {
    return _firestore
        .collection(_collectionName)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Match.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  // Delete a specific match
  Future<void> deleteMatch(String matchId) async {
    try {
      await _firestore.collection(_collectionName).doc(matchId).delete();
    } catch (e) {
      print('Error deleting match: $e');
      rethrow;
    }
  }

  // Clear all matches
  Future<void> clearAllMatches() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection(_collectionName).get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Error clearing matches: $e');
      rethrow;
    }
  }
}