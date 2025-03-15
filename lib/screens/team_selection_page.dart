import 'package:flutter/material.dart';
import 'words_per_player_page.dart';

class TeamSelectionPage extends StatefulWidget {
  final List<String> players;

  const TeamSelectionPage({super.key, required this.players});

  @override
  State<TeamSelectionPage> createState() => _TeamSelectionPageState();
}

class _TeamSelectionPageState extends State<TeamSelectionPage> {
  List<String> team1 = [];
  List<String> team2 = [];
  List<String> unassignedPlayers = [];

  bool isRandom = false;

  @override
  void initState() {
    super.initState();
    unassignedPlayers = List.from(widget.players);
  }

  void _assignRandomly() {
    setState(() {
      List<String> allPlayers = List.from(widget.players)..shuffle();
      int midPoint = (allPlayers.length / 2).ceil();

      team1 = allPlayers.sublist(0, midPoint);
      team2 = allPlayers.sublist(midPoint);
      unassignedPlayers.clear();
    });
  }

  Widget _buildDraggablePlayer(String player) {
    return LongPressDraggable<String>(
      data: player,
      feedback: Material(
        color: Colors.transparent,
        child: Card(
          elevation: 4.0,
          child: ListTile(title: Text(player)),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: Card(
          child: ListTile(title: Text(player)),
        ),
      ),
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Text(player),
        ),
      ),
    );
  }

  Widget _buildTeamColumn(String title, List<String> team, Color color, Function(String) onAccept) {
    return Expanded(
      child: DragTarget<String>(
        onWillAccept: (data) => true,
        onAccept: (player) {
          setState(() {
            unassignedPlayers.remove(player);
            team1.remove(player);
            team2.remove(player);
            onAccept(player);
          });
        },
        builder: (context, candidateData, rejectedData) => Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  children: team.map((player) => _buildDraggablePlayer(player)).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Team Selection')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Assign Randomly  '),
                Switch(
                  value: isRandom,
                  onChanged: (value) {
                    setState(() {
                      isRandom = value;
                      if (isRandom) {
                        _assignRandomly();
                      } else {
                        unassignedPlayers = List.from(widget.players);
                        team1.clear();
                        team2.clear();
                      }
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Row(
                children: [
                  _buildTeamColumn('Team 1', team1, Colors.blue[100]!, (player) => team1.add(player)),
                  Expanded(
                    child: DragTarget<String>(
                      onWillAccept: (data) => true,
                      onAccept: (player) {
                        setState(() {
                          team1.remove(player);
                          team2.remove(player);
                          unassignedPlayers.add(player);
                        });
                      },
                      builder: (context, candidateData, rejectedData) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Unassigned Players',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: ListView(
                                children: unassignedPlayers.map((player) => _buildDraggablePlayer(player)).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _buildTeamColumn('Team 2', team2, Colors.red[100]!, (player) => team2.add(player)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (team1.isEmpty || team2.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Both teams must have at least one player')),
                  );
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WordsPerPlayerPage(
                        team1: team1,
                        team2: team2,
                      ),
                    ),
                  );
                }
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}