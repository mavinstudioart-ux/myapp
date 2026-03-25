import 'package:flutter/material.dart';
import '../game_state.dart';
import 'package:provider/provider.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Log Aktivitas"), backgroundColor: Colors.transparent, elevation: 0),
      body: ListView.builder(
        reverse: true,
        itemCount: gameState.activityLog.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(gameState.activityLog[index], style: const TextStyle(fontSize: 12, color: Colors.white70)),
          );
        },
      ),
    );
  }
}
