import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../game_state.dart';
import '../utils/utils.dart';

class BankScreen extends StatefulWidget {
  const BankScreen({super.key});

  @override
  State<BankScreen> createState() => _BankScreenState();
}

class _BankScreenState extends State<BankScreen> {
  final TextEditingController _savingsController = TextEditingController();
  final TextEditingController _loanController = TextEditingController();

  @override
  void dispose() {
    _savingsController.dispose();
    _loanController.dispose();
    super.dispose();
  }

  void _showTransactionDialog(
      {required BuildContext context,
      required String title,
      required TextEditingController controller,
      required Function(double) onConfirm}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            decoration: const InputDecoration(
              labelText: 'Jumlah',
              prefixText: 'Rp ',
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Batal')),
            TextButton(
                onPressed: () {
                  final amount = double.tryParse(controller.text) ?? 0;
                  if (amount > 0) {
                    onConfirm(amount);
                    Navigator.of(context).pop();
                    controller.clear();
                  }
                },
                child: const Text('Konfirmasi')),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    final bank = gameState.character.bankAccount;
    final character = gameState.character;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Bank'), backgroundColor: Colors.transparent, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInfoCard(
                title: 'Tabungan',
                value: formatCurrency(bank.savings),
                icon: Icons.savings,
                color: Colors.green),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () => _showTransactionDialog(context: context, title: 'Setor Tabungan', controller: _savingsController, onConfirm: gameState.depositSavings), child: const Text('Setor')),
                ElevatedButton(onPressed: () => _showTransactionDialog(context: context, title: 'Tarik Tabungan', controller: _savingsController, onConfirm: gameState.withdrawSavings), child: const Text('Tarik')),
              ],
            ),
            const SizedBox(height: 24),
            _buildInfoCard(
                title: 'Pinjaman',
                value: formatCurrency(bank.loan),
                icon: Icons.credit_card,
                color: Colors.red),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () => _showTransactionDialog(
                        context: context,
                        title: 'Ambil Pinjaman',
                        controller: _loanController,
                        onConfirm: gameState.takeLoan),
                    child: const Text('Ambil')),
                ElevatedButton(
                    onPressed: () => _showTransactionDialog(
                        context: context,
                        title: 'Bayar Pinjaman',
                        controller: _loanController,
                        onConfirm: gameState.repayLoan),
                    child: const Text('Bayar')),
              ],
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Informasi Akun', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 12),
                    _buildInfoRow('Uang Tunai', formatCurrency(character.money)),
                    _buildInfoRow('Bunga Tabungan', '${(bank.savingsInterestRate * 100).toStringAsFixed(1)}% / minggu'),
                    _buildInfoRow('Bunga Pinjaman', '${(bank.loanInterestRate * 100).toStringAsFixed(1)}% / minggu'),
                    _buildInfoRow('Batas Pinjaman', formatCurrency(gameState.maxLoanAmount)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required String value, required IconData icon, required Color color}) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(value, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
