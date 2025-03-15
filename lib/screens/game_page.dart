import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'dart:async';

class GamePage extends StatefulWidget {
  final List<String> team1;
  final List<String> team2;
  final List<String> allWords;


  const GamePage({
    super.key,
    required this.team1,
    required this.team2,
    required this.allWords,
  });

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int currentTeamIndex = 0;
  int currentPlayerIndex = 0;
  int currentWordIndex = 0;
  int remainingTime = 60;
  bool hasPassed = false;
  Timer? _timer;
  bool isPlaying = false;
  late List<String> remainingWords;
  late List<String> originalWords;
  int currentRound = 1;

  @override
  void initState() {
    super.initState();
    // Flatten the nested list of words
    originalWords = widget.allWords.expand<String>((words) => [words]).toList();
    remainingWords = List.from(originalWords);
    remainingWords.shuffle();
  }

  void startTimer() {
    setState(() {
      isPlaying = true;
      remainingTime = 60;
      hasPassed = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          endTurn();
        }
      });
    });
  }

  void endTurn() {
    _timer?.cancel();
    setState(() {
      isPlaying = false;
      // Sıradaki oyuncuya geç
      if (currentTeamIndex == 0) {
        currentPlayerIndex = (currentPlayerIndex + 1) % widget.team1.length;
        if (currentPlayerIndex == 0) currentTeamIndex = 1;
      } else {
        currentPlayerIndex = (currentPlayerIndex + 1) % widget.team2.length;
        if (currentPlayerIndex == 0) currentTeamIndex = 0;
      }
    });
  }

  void handleCorrectAnswer() {
    if (!isPlaying) return;

    setState(() {
      // Remove the current word from remaining words
      remainingWords.removeAt(currentWordIndex);

      if (remainingWords.isEmpty) {
        // Round is complete
        _timer?.cancel();
        if (currentRound < 4) {
          currentRound++;
          // Reset words for new round
          remainingWords = List.from(originalWords);
          remainingWords.shuffle();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Round $currentRound'),
              content: const Text('Get ready for the next round!'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          // Game over after 4 rounds
          showGameOverDialog();
        }
      }
    });

    // Update score
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    if (currentTeamIndex == 0) {
      gameProvider.incrementTeam1Score();
    } else {
      gameProvider.incrementTeam2Score();
    }
  }

  void handlePass() {
    if (!isPlaying || hasPassed) return;

    setState(() {
      hasPassed = true;
      // Move current word to end of remaining words
      if (remainingWords.isNotEmpty) {
        String currentWord = remainingWords[currentWordIndex];
        remainingWords.removeAt(currentWordIndex);
        remainingWords.add(currentWord);
      }
    });
  }

  void showGameOverDialog() {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('The end!'),
        content: Text(
          'Team 1: ${gameProvider.team1Score}\n'
          'Team 2: ${gameProvider.team2Score}\n\n'
          'Winner: ${gameProvider.team1Score > gameProvider.team2Score ? "Team 1" : "Team 2"}!'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            child: const Text('Back to main menu'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    String currentPlayer = currentTeamIndex == 0 
        ? widget.team1[currentPlayerIndex]
        : widget.team2[currentPlayerIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Round ${gameProvider.currentRound}/4'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Team 1: ${gameProvider.team1Score}  -  Team 2: ${gameProvider.team2Score}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            Text('Current Player: $currentPlayer',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text('Remaining Time: $remainingTime',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            if (isPlaying) ...[
              const SizedBox(height: 40),
              Text(remainingWords[currentWordIndex],
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: handleCorrectAnswer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    ),
                    child: const Text('Correct!'),
                  ),
                  ElevatedButton(
                    onPressed: hasPassed ? null : handlePass,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    ),
                    child: const Text('Pass'),
                  ),
                ],
              ),
            ] else ...[
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: startTimer,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                ),
                child: const Text('START!'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}