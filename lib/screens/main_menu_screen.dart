import 'package:flutter/material.dart';
import '../game_state.dart';
import 'character_creation_screen.dart';
import 'game_screen.dart';
import '../utils/utils.dart';
import '../widgets/gradient_background.dart';
import 'package:provider/provider.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.transparent, // Important for the gradient to show
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('CEO Journey', style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Dari Nol Menjadi CEO', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70)),
            const SizedBox(height: 50),
            ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GradientBackground(child: CharacterCreationScreen()))), child: const Text("Game Baru")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (gameState.gameStarted) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const GradientBackground(child: GameScreen())));
                } else {
                  showSnackbar("Tidak ada game yang disimpan. Mulai game baru.", isError: true);
                }
              },
              child: const Text("Lanjutkan Game"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () {}, child: const Text("Pengaturan")),
          ],
        ),
      ),
    );
  }
}
