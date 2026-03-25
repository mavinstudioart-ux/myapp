import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../game_state.dart';
import '../models/models.dart';
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
      Provider.of<GameState>(context, listen: false)
          .addListener(_handleGameStateChanges);
    });
  }

  @override
  void dispose() {
    Provider.of<GameState>(context, listen: false)
        .removeListener(_handleGameStateChanges);
    super.dispose();
  }

  void _handleGameStateChanges() {
    final gameState = Provider.of<GameState>(context, listen: false);
    if (mounted && gameState.snackbarMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(gameState.snackbarMessage!),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    if (mounted && gameState.isGameOver) {
      _showGameOverDialog();
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: Text(
            Provider.of<GameState>(context, listen: false).activityLog.first),
        actions: [
          TextButton(
            onPressed: () {
              Provider.of<GameState>(context, listen: false).startNewGame("Player");
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
      backgroundColor: Colors.transparent,
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
        elevation: 4.0,
        child: const Icon(Icons.arrow_forward_ios),
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
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  character.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                _buildDotPattern(),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              formatCurrency(character.money),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Usia: ${character.age} • Minggu: ${character.week}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const Divider(height: 32, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusIndicator(icon: Icons.health_and_safety, value: character.health, color: Colors.red.shade400),
                _buildStatusIndicator(icon: Icons.sentiment_satisfied, value: character.mood, color: Colors.blue.shade400),
                _buildStatusIndicator(icon: Icons.fastfood, value: character.hunger, color: Colors.orange.shade400),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator({required IconData icon, required double value, required Color color}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
              Text(
                '${value.toInt()}%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDotPattern() {
    return SizedBox(
      width: 48,
      height: 32,
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        alignment: WrapAlignment.end,
        children: List.generate(18, (index) {
          double opacity = (1.0 - ((index % 6) / 7.0)) * 0.5;
          return Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(opacity),
              shape: BoxShape.circle,
            ),
          );
        }),
      ),
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
