import 'package:flutter/material.dart';
import 'game_page.dart';

class WordEntryPage extends StatefulWidget {
  final List<String> team1;
  final List<String> team2;
  final int currentPlayerIndex;
  final int wordsPerPlayer;  // Added this parameter

  const WordEntryPage({
    super.key,
    required this.team1,
    required this.team2,
    required this.currentPlayerIndex,
    required this.wordsPerPlayer,
  });

  @override
  State<WordEntryPage> createState() => _WordEntryPageState();
}

class _WordEntryPageState extends State<WordEntryPage> {
  List<String> allWords = [];
  late int currentPlayerIndex;
  late List<TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    currentPlayerIndex = widget.currentPlayerIndex;
    // Initialize controllers based on wordsPerPlayer
    controllers = List.generate(widget.wordsPerPlayer, (_) => TextEditingController());
  }

  String get currentPlayerName {
    final allPlayers = [...widget.team1, ...widget.team2];
    return currentPlayerIndex < allPlayers.length ? allPlayers[currentPlayerIndex] : 'Unknown Player';
  }

  void _submitWords() {
    if (controllers.any((controller) => controller.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all words')),
      );
      return;
    }

    // Add entered words to the list
    setState(() {
      allWords.addAll(controllers.map((c) => c.text));
    });

    // If this is the last player, navigate to the game page
    if (currentPlayerIndex == widget.team1.length + widget.team2.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GamePage(
            team1: widget.team1,
            team2: widget.team2,
            allWords: allWords,
          ),
        ),
      );
    } else {
      // Move to the next player
      setState(() {
        currentPlayerIndex++;
        controllers.forEach((controller) => controller.clear());
      });
    }
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Word Entry')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Player: $currentPlayerName',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Enter ${widget.wordsPerPlayer} words',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: widget.wordsPerPlayer,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: controllers[index],
                      decoration: InputDecoration(
                        labelText: 'Enter word ${index + 1}',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _submitWords,
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}