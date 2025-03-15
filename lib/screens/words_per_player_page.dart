import 'package:flutter/material.dart';
import 'word_entry_page.dart';

class WordsPerPlayerPage extends StatefulWidget {
  final List<String> team1;
  final List<String> team2;

  const WordsPerPlayerPage({
    Key? key,
    required this.team1,
    required this.team2,
  }) : super(key: key);

  @override
  State<WordsPerPlayerPage> createState() => _WordsPerPlayerPageState();
}

class _WordsPerPlayerPageState extends State<WordsPerPlayerPage> {
  int wordsPerPlayer = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Words Per Player'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'How many words should each player write?',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Text(
              wordsPerPlayer.toString(),
              style: Theme.of(context).textTheme.displayMedium,
            ),
            Slider(
              value: wordsPerPlayer.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              label: wordsPerPlayer.toString(),
              onChanged: (value) {
                setState(() {
                  wordsPerPlayer = value.toInt();
                });
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WordEntryPage(
                      team1: widget.team1,
                      team2: widget.team2,
                      currentPlayerIndex: 0,
                      wordsPerPlayer: wordsPerPlayer,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}