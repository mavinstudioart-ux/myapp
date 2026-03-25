import 'package:flutter/material.dart';
import '../game_state.dart';
import '../models/models.dart';
import 'package:provider/provider.dart';
import '../utils/utils.dart';

class InvestmentScreen extends StatelessWidget {
  const InvestmentScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    final amountController = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
          title: const Text("Pasar Investasi"),
          backgroundColor: Colors.transparent,
          elevation: 0),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: gameState.investmentMarket.length,
        itemBuilder: (context, index) {
          var asset = gameState.investmentMarket[index];
          var ownedAsset = gameState.character.investments
              .firstWhere((inv) => inv.name == asset.name, orElse: () => Investment(name: "", price: 0, units: 0));
          return Card(
            child: ExpansionTile(
              title: Text(asset.name),
              subtitle: Text(
                  "Harga: ${formatCurrency(asset.price)}\nDimiliki: ${ownedAsset.units.toStringAsFixed(2)} unit"),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                          controller: amountController,
                          decoration: const InputDecoration(labelText: "Jumlah Unit"),
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true)),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              final amount =
                                  double.tryParse(amountController.text) ?? 0;
                              gameState.buyInvestment(asset, amount);
                              amountController.clear();
                            },
                            child: const Text("Beli"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              final amount =
                                  double.tryParse(amountController.text) ?? 0;
                              gameState.sellInvestment(asset, amount);
                              amountController.clear();
                            },
                            child: const Text("Jual"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
