import 'package:flutter/material.dart';
import '../game_state.dart';
import 'package:provider/provider.dart';
import '../utils/utils.dart';

class JobScreen extends StatelessWidget {
  const JobScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text("Bursa Kerja"), backgroundColor: Colors.transparent, elevation: 0),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: gameState.jobBoard.length,
        itemBuilder: (context, index) {
          var job = gameState.jobBoard[index];
          bool isQualified = gameState.character.skills.contains(job.requiredSkill);
          bool isCurrentJob = gameState.character.currentJob?.title == job.title;
          String buttonText = isCurrentJob ? "Sedang Dikerjakan" : (isQualified ? "Lamar" : "Tidak Memenuhi Syarat");
          return Card(
            child: ListTile(
              title: Text(job.title),
              subtitle: Text("Gaji: ${formatCurrency(job.salary)}/minggu\nSyarat: ${job.requiredSkill}"),
              trailing: ElevatedButton(onPressed: isQualified && !isCurrentJob ? () => gameState.applyForJob(job) : null, child: Text(buttonText)),
            ),
          );
        },
      ),
    );
  }
}
