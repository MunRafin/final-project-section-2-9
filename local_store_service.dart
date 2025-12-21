import '../models/match.dart';

class LocalStoreService {
  static final List<MatchRecord> history = [];

  static void saveMatch(MatchRecord match) {
    history.insert(0, match); // Add to start of list
  }
}