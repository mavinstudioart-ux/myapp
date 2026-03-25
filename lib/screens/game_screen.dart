import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../game_state.dart';
import '../models/models.dart'; // Impor yang hilang
import '../utils/utils.dart';
import 'activity_log_screen.dart';
import 'bank_screen.dart';
import 'business_screen.dart';
import 'education_screen.dart';
import 'investment_screen.dart';
import 'job_screen.dart';
import 'profile_screen.dart';
import 'shop_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GameState>(context, listen: false).addListener(_handleGameStateChanges);
    });
  }

  @override
  void dispose() {
    Provider.of<GameState>(context, listen: false).removeListener(_handleGameStateChanges);
    super.dispose();
  }

  void _handleGameStateChanges() {
    final gameState = Provider.of<GameState>(context, listen: false);
    if (gameState.snackbarMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(gameState.snackbarMessage!),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
    if (gameState.isGameOver) {
      _showGameOverDialog();
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: Text(Provider.of<GameState>(context, listen: false).activityLog.first),
        actions: [
          TextButton(
            onPressed: () {
              Provider.of<GameState>(context, listen: false).startNewGame("Player"); // Restart
              Navigator.of(context).pop();
            },
            child: const Text('Mulai Lagi'),
          ),
        ],
      ),
    );
  }

  void _showModal(BuildContext context, Widget screen) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Make modal background transparent
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.6,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0D1636), Color(0xFF16213E)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: screen,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    final character = gameState.character;

    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D1636), Color(0xFF223A6A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 16),
                _buildPlayerStatusCard(context, character),
                const SizedBox(height: 24),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.4,
                    children: <Widget>[
                      _buildNavCard(context, icon: Icons.work, label: "Pekerjaan", onTap: () => _showModal(context, const JobScreen())),
                      _buildNavCard(context, icon: Icons.business_center, label: "Bisnis", onTap: () => _showModal(context, const BusinessScreen())),
                      _buildNavCard(context, icon: Icons.shopping_cart, label: "Belanja", onTap: () => _showModal(context, const ShopScreen())),
                      _buildNavCard(context, icon: Icons.account_balance, label: "Bank", onTap: () => _showModal(context, const BankScreen())),
                      _buildNavCard(context, icon: Icons.school, label: "Pendidikan", onTap: () => _showModal(context, const EducationScreen())),
                      _buildNavCard(context, icon: Icons.history_edu, label: "Log", onTap: () => _showModal(context, ActivityLogScreen(log: gameState.activityLog))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => gameState.nextWeek(),
        tooltip: 'Minggu Depan',
        child: const Icon(Icons.arrow_forward_ios),
        elevation: 4.0,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: const Color.fromRGBO(22, 33, 62, 0.9),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildBottomNavIcon(context, icon: Icons.person, label: "Profil", onTap: () => _showModal(context, const ProfileScreen())),
            _buildBottomNavIcon(context, icon: Icons.trending_up, label: "Investasi", onTap: () => _showModal(context, const InvestmentScreen())),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildPlayerStatusCard(BuildContext context, Character character) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Player Name and Money
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(character.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                Text(formatCurrency(character.money), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
              ],
            ),
            const Divider(height: 24, color: Colors.white24),
            // Age and Week
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAgeWeekInfo('Usia', character.age.toString(), 'tahun'),
                _buildAgeWeekInfo('Minggu', character.week.toString(), 'ke'),
              ],
            ),
            const SizedBox(height: 16),
            // Status Percentages
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatusCircle("Health", character.health, Colors.greenAccent),
                _buildStatusCircle("Mood", character.mood, Colors.blueAccent),
                _buildStatusCircle("Hunger", character.hunger, Colors.orangeAccent),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAgeWeekInfo(String label, String value, String suffix) {
    return Column(
      children: [
        Text(label.toUpperCase(), style: const TextStyle(fontSize: 12, color: Colors.white70, letterSpacing: 1.2)),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(width: 4),
            Text(suffix, style: const TextStyle(fontSize: 14, color: Colors.white70)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusCircle(String label, double value, Color color) {
    return Column(
      children: [
        Text(label.toUpperCase(), style: const TextStyle(fontSize: 12, color: Colors.white70, letterSpacing: 1.2)),
        const SizedBox(height: 8),
        Text('${value.toInt()}%', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildNavCard(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavIcon(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [Icon(icon, color: Colors.white, size: 24), const SizedBox(height: 4), Text(label, style: const TextStyle(color: Colors.white, fontSize: 12))],
        ),
      ),
    );
  }
}
