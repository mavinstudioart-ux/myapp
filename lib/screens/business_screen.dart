import 'package:flutter/material.dart';
import '../game_state.dart';
import 'package:provider/provider.dart';
import '../utils/utils.dart';

class BusinessScreen extends StatelessWidget {
  const BusinessScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            title: const Text("Manajemen Bisnis"),
            backgroundColor: Colors.transparent,
            elevation: 0,
            bottom: const TabBar(tabs: [
              Tab(text: "Beli Bisnis"),
              Tab(text: "Bisnis Saya")
            ])),
        body: TabBarView(
          children: [
            ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: gameState.businessMarket.length,
              itemBuilder: (context, index) {
                var biz = gameState.businessMarket[index];
                bool canBuy = gameState.character.money >= biz.capitalCost;
                return Card(
                  child: ListTile(
                    title: Text(biz.name),
                    subtitle: Text(
                        "Modal: ${formatCurrency(biz.capitalCost)}\nPotensi Profit/Minggu: ${formatCurrency(biz.baseWeeklyRevenue - biz.weeklyOperatingCost)}"),
                    trailing: ElevatedButton(
                        onPressed: canBuy ? () => gameState.startBusiness(biz) : null,
                        child: const Text("Beli")),
                  ),
                );
              },
            ),
            gameState.character.businesses.isEmpty
                ? const Center(child: Text("Anda belum memiliki bisnis."))
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: gameState.character.businesses.length,
                    itemBuilder: (context, index) {
                      var biz = gameState.character.businesses[index];
                      return Card(
                        child: ListTile(
                          title: Text(biz.name),
                          subtitle: Text(
                              "Sektor: ${biz.sector}\nBiaya Operasional: ${formatCurrency(biz.weeklyOperatingCost)}/minggu"),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
