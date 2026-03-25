import 'package:flutter/material.dart';
import '../game_state.dart';
import 'game_screen.dart';
import '../widgets/gradient_background.dart';
import 'package:provider/provider.dart';

class CharacterCreationScreen extends StatefulWidget {
  const CharacterCreationScreen({super.key});

  @override
  State<CharacterCreationScreen> createState() => _CharacterCreationScreenState();
}

class _CharacterCreationScreenState extends State<CharacterCreationScreen> {
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text("Buat Karakter"), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Nama Karakter")),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_nameController.text.isNotEmpty) {
                    gameState.startNewGame(_nameController.text);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const GradientBackground(child: GameScreen())));
                  }
                },
                child: const Text("Mulai Petualangan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
