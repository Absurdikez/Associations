import 'package:flutter/material.dart';
import 'team_selection_page.dart';

class PlayerCountPage extends StatefulWidget {
  const PlayerCountPage({super.key});

  @override
  State<PlayerCountPage> createState() => _PlayerCountPageState();
}

class _PlayerCountPageState extends State<PlayerCountPage> {
  int playerCount = 2;
  final List<TextEditingController> playerNameControllers = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < playerCount; i++) {
      playerNameControllers.add(TextEditingController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Player Count and Names'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Player Count: $playerCount'),
            Slider(
              value: playerCount.toDouble(),
              min: 2,
              max: 10,
              divisions: 8,
              label: playerCount.toString(),
              onChanged: (value) {
                setState(() {
                  playerCount = value.toInt();
                  if (playerNameControllers.length < playerCount) {
                    for (int i = playerNameControllers.length; i < playerCount; i++) {
                      playerNameControllers.add(TextEditingController());
                    }
                  } else {
                    playerNameControllers.removeRange(playerCount, playerNameControllers.length);
                  }
                });
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: playerCount,
                itemBuilder: (context, index) {
                  return TextField(
                    controller: playerNameControllers[index],
                    decoration: InputDecoration(
                      labelText: 'Player ${index + 1} Name',
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                List<String> playerNames = playerNameControllers.map((controller) => controller.text).toList();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TeamSelectionPage(
                      players: playerNames,  
                    ),
                  ),
                );
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}