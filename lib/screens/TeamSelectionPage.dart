import 'package:flutter/material.dart';
import 'word_entry_page.dart';

class TeamSelectionPage extends StatefulWidget {
  final List<String> playerNames;

  const TeamSelectionPage({super.key, required this.playerNames});

  @override
  State<TeamSelectionPage> createState() => _TeamSelectionPageState();
}

class _TeamSelectionPageState extends State<TeamSelectionPage> {
  final List<String> team1 = [];
  final List<String> team2 = [];
  late List<String> unassignedPlayers;

  @override
  void initState() {
    super.initState();
    unassignedPlayers = List.from(widget.playerNames);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Team Selection')),
      body: Row(
        children: [
          Expanded(
            child: _buildTeamColumn('Team 1', team1, Colors.blue[100]!),
          ),
          Expanded(
            child: _buildUnassignedColumn(),
          ),
          Expanded(
            child: _buildTeamColumn('Team 2', team2, Colors.red[100]!),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: team1.length == team2.length ? 
            () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => WordEntryPage(
                    team1: team1,
                    team2: team2,
                    currentPlayerIndex: 0,
                    wordsPerPlayer: 3,
                  ),
              ),
            ) : null,
          child: const Text('Continue'),
        ),
      ),
    );
  }

  Widget _buildTeamColumn(String title, List<String> team, Color color) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: DragTarget<String>(
        onAcceptWithDetails: (details) {
          setState(() {
            team.add(details.data);
            unassignedPlayers.remove(details.data);
          });
        },
        builder: (context, candidateData, rejectedData) {
          return Column(
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              Expanded(
                child: ListView.builder(
                  itemCount: team.length,
                  itemBuilder: (context, index) {
                    return Draggable<String>(
                      data: team[index],
                      feedback: Card(
                        child: ListTile(title: Text(team[index])),
                      ),
                      childWhenDragging: const SizedBox(),
                      onDragCompleted: () {
                        setState(() {
                          team.removeAt(index);
                        });
                      },
                      child: Card(
                        child: ListTile(title: Text(team[index])),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUnassignedColumn() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text('Assaigned Players', 
            style: Theme.of(context).textTheme.titleLarge
          ),
          Expanded(
            child: ListView.builder(
              itemCount: unassignedPlayers.length,
              itemBuilder: (context, index) {
                return Draggable<String>(
                  data: unassignedPlayers[index],
                  feedback: Card(
                    child: ListTile(
                      title: Text(unassignedPlayers[index]),
                    ),
                  ),
                  childWhenDragging: const SizedBox(),
                  child: Card(
                    child: ListTile(
                      title: Text(unassignedPlayers[index]),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}