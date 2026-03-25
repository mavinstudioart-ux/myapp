import 'package:flutter/material.dart';
import '../game_state.dart';
import 'package:provider/provider.dart';

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Pusat Pendidikan"), backgroundColor: Colors.transparent, elevation: 0),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: gameState.educationPrograms.length,
        itemBuilder: (context, index) {
          var course = gameState.educationPrograms[index];
          bool canEnroll = gameState.character.money >= course.cost && !gameState.character.isStudying() && gameState.character.skills.contains(course.requiredSkill);
          bool hasSkill = gameState.character.skills.contains(course.skillAwarded);
          String buttonText = hasSkill ? "Selesai" : (gameState.character.isStudying() ? "Sedang Belajar" : "Daftar");
          return Card(
            child: ListTile(
              title: Text(course.name),
              subtitle: Text("${course.description}\nBiaya: Rp ${course.cost.toStringAsFixed(0)}"),
              trailing: ElevatedButton(onPressed: hasSkill || !canEnroll ? () => gameState.enrollInEducation(course) : null, child: Text(buttonText)),
            ),
          );
        },
      ),
    );
  }
}
