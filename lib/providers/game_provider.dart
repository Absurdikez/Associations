import 'package:flutter/foundation.dart';

class GameProvider with ChangeNotifier {
  int team1Score = 0;
  int team2Score = 0;
  int currentRound = 1;
  bool isGameActive = false;
  List<String> wordPool = [];

  void incrementTeam1Score() {
    team1Score++;
    notifyListeners();
  }

  void incrementTeam2Score() {
    team2Score++;
    notifyListeners();
  }

  void nextRound() {
    currentRound++;
    notifyListeners();
  }

  void toggleGameActive() {
    isGameActive = !isGameActive;
    notifyListeners();
  }

  void setWordPool(List<String> words) {
    wordPool = words;
    wordPool.shuffle();
    notifyListeners();
  }
}