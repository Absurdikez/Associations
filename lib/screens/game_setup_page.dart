import 'package:flutter/material.dart';
import 'word_entry_page.dart';
import 'team_selection_page.dart'; 


class GameSetupPage extends StatefulWidget {
  const GameSetupPage({super.key});

  @override
  _GameSetupPageState createState() => _GameSetupPageState();
}

class _GameSetupPageState extends State<GameSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers = [];
  int playerCount = 4;
  bool isManualTeams = false;

  @override
  void initState() {
    super.initState();
    _updateControllers();
  }

  void _updateControllers() {
    _controllers.clear();
    for (int i = 0; i < playerCount; i++) {
      _controllers.add(TextEditingController());
    }
  }

  void _onPlayerCountChanged(String? value) {
    if (value != null) {
      setState(() {
        playerCount = int.parse(value);
        _updateControllers();
      });
    }
  }

  void _submitPlayers() {
    if (_formKey.currentState!.validate()) {
      List<String> players = _controllers.map((c) => c.text).toList();
      
      if (isManualTeams) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TeamSelectionPage(players: players), // Büyük harfle başlayan sınıf adı
          ),
        );
      } else {
        // Rastgele Team ataması
        players.shuffle();
        List<String> team1 = [];
        List<String> team2 = [];
        
        for (int i = 0; i < players.length; i++) {
          if (i < players.length ~/ 2) {
            team1.add(players[i]);
          } else {
            team2.add(players[i]);
          }
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WordEntryPage(
              team1: team1,
              team2: team2,
              currentPlayerIndex: 0,
              wordsPerPlayer: 5,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Game Setup')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            DropdownButtonFormField<String>(
              value: playerCount.toString(),
              decoration: InputDecoration(labelText: 'Number of Players'),
              items: ['4', '6', '8', '10']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: _onPlayerCountChanged,
            ),
            SwitchListTile(
              title: Text('Manual Team Selection'),
              value: isManualTeams,
              onChanged: (value) => setState(() => isManualTeams = value),
            ),
            ...List.generate(
              playerCount,
              (index) => Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _controllers[index],
                  decoration: InputDecoration(
                    labelText: 'Player ${index + 1} Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter player name';
                    }
                    return null;
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitPlayers,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text('Continue to Word Entry'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}