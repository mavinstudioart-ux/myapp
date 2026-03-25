import 'package:flutter/material.dart';
import '../game_state.dart';
import 'package:provider/provider.dart';
import '../utils/utils.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            title: const Text("Toko"),
            backgroundColor: Colors.transparent,
            elevation: 0,
            bottom: const TabBar(
                tabs: [Tab(text: "Makanan"), Tab(text: "Properti")])),
        body: TabBarView(
          children: [
            ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: gameState.foodMarket.length,
              itemBuilder: (context, index) {
                var food = gameState.foodMarket[index];
                bool canBuy = gameState.character.money >= food.price;
                return Card(
                  child: ListTile(
                    title: Text(food.name),
                    subtitle: Text(
                        "Harga: ${formatCurrency(food.price)}\n+${food.healthBonus} Kesehatan, +${food.moodBonus} Mood"),
                    trailing: ElevatedButton(
                        onPressed: canBuy ? () => gameState.buyFood(food) : null,
                        child: const Text("Beli")),
                  ),
                );
              },
            ),
            ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: gameState.propertyMarket.length,
              itemBuilder: (context, index) {
                var prop = gameState.propertyMarket[index];
                bool canBuy = gameState.character.money >= prop.price;
                return Card(
                  child: ListTile(
                    title: Text(prop.name),
                    subtitle: Text(
                        "Harga: ${formatCurrency(prop.price)}\nPendapatan: ${formatCurrency(prop.weeklyIncome)}/minggu"),
                    trailing: ElevatedButton(
                        onPressed: canBuy ? () => gameState.buyProperty(prop) : null,
                        child: const Text("Beli")),
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
