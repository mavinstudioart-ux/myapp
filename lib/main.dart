import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const CEOJourneyApp());
}

// -- DATA MODELS --

class Character {
  int age = 18;
  int week = 1;
  double money = 5000000;
  double health = 100;
  double hunger = 100;
  double mood = 70;
  Job? currentJob;
  List<Property> properties = [];
  List<Investment> investments = [];
  List<String> skills = [];
  double weeklyIncome = 0;
  double weeklyExpenses = 0;

  void resetWeeklyFinancials() {
    weeklyIncome = 0;
    weeklyExpenses = 0;
  }
}

class Job {
  final String title;
  final String sector;
  final double salary;
  Job({required this.title, required this.sector, required this.salary});
}

class Property {
  final String name;
  final double price;
  final double weeklyIncome;
  Property({required this.name, required this.price, required this.weeklyIncome});
}

class Investment {
  final String name;
  double price;
  double units;
  Investment({required this.name, required this.price, this.units = 0});
}

class Food {
  final String name;
  final double price;
  final double healthBonus;
  final double moodBonus;
  Food({required this.name, required this.price, required this.healthBonus, required this.moodBonus});
}

// -- GAME STATE MANAGEMENT --

class GameState extends ChangeNotifier {
  Character character = Character();
  List<String> activityLog = ["Welcome to CEO Journey!"];
  String weeklyNews = "No important news this week.";

  final List<Job> _jobBoard = [];
  final List<Investment> _investmentMarket = [
    Investment(name: "Tech Stock (BCAC)", price: 5000),
    Investment(name: "Crypto (BTCF)", price: 500000000),
    Investment(name: "Gold", price: 1000000),
  ];
  final List<Food> _foodMarket = [
    Food(name: "Instant Noodles (1 Week)", price: 50000, healthBonus: 2, moodBonus: 1),
    Food(name: "Warteg Rice (1 Week)", price: 150000, healthBonus: 5, moodBonus: 3),
    Food(name: "Healthy Catering (1 Week)", price: 400000, healthBonus: 10, moodBonus: 5),
  ];
  final List<Property> _propertyMarket = [
    Property(name: "Studio Apartment", price: 300000000, weeklyIncome: 1500000),
    Property(name: "Cluster House", price: 750000000, weeklyIncome: 4000000),
  ];

  GameState() {
    _generateJobs();
  }

  void _generateJobs() {
    _jobBoard.clear();
    _jobBoard.addAll([
      Job(title: "Cashier", sector: "Retail", salary: 800000),
      Job(title: "Junior Programmer", sector: "Tech", salary: 1500000),
      Job(title: "Graphic Designer Intern", sector: "Creative", salary: 700000),
    ]);
    notifyListeners();
  }

  void nextWeek() {
    character.resetWeeklyFinancials();
    character.week++;

    if (character.week % 52 == 0) {
      character.age++;
      activityLog.clear();
      logActivity("Happy ${character.age}th birthday!");
    }

    character.hunger = max(0, character.hunger - 5);
    if (character.hunger < 20) {
      character.health = max(0, character.health - 5);
      character.mood = max(0, character.mood - 5);
      logActivity("You are very hungry! Health and mood are decreasing.");
    }
    if (character.health <= 0) {
      logActivity("Your health has reached zero. Your journey has ended.");
      return;
    }

    if (character.currentJob != null) {
      double salary = character.currentJob!.salary;
      character.money += salary;
      addIncome(salary);
      logActivity("Salary received: Rp ${salary.toStringAsFixed(0)}");
    }

    for (var prop in character.properties) {
      character.money += prop.weeklyIncome;
      addIncome(prop.weeklyIncome);
      logActivity("Rental income from ${prop.name}: Rp ${prop.weeklyIncome.toStringAsFixed(0)}");
    }

    _handleWeeklyEvent();
    if (character.week % 4 == 0) _generateJobs();

    notifyListeners();
  }

  void _handleWeeklyEvent() {
    // Simplified event system
  }

  void addIncome(double amount) {
    character.weeklyIncome += amount;
  }

  void addExpense(double amount) {
    character.weeklyExpenses += amount;
  }

  void logActivity(String message) {
    activityLog.insert(0, "[Age ${character.age}, W${character.week}] $message");
    if (activityLog.length > 20) activityLog.removeLast();
    notifyListeners();
  }

  void buyFood(Food food) {
    if (character.money >= food.price) {
      character.money -= food.price;
      addExpense(food.price);
      character.hunger = min(100, character.hunger + 25);
      character.health = min(100, character.health + food.healthBonus);
      character.mood = min(100, character.mood + food.moodBonus);
      logActivity("Bought '${food.name}' for Rp ${food.price.toStringAsFixed(0)}.");
      notifyListeners();
    } else {
      logActivity("Not enough money to buy '${food.name}'.");
    }
  }

  void buyInvestment(Investment asset, double unitsToBuy) {
    double totalCost = asset.price * unitsToBuy;
    if (character.money >= totalCost) {
      character.money -= totalCost;
      addExpense(totalCost);
      var existing = character.investments.indexWhere((inv) => inv.name == asset.name);
      if (existing != -1) {
        character.investments[existing].units += unitsToBuy;
      } else {
        character.investments.add(Investment(name: asset.name, price: asset.price, units: unitsToBuy));
      }
      logActivity("Bought $unitsToBuy units of ${asset.name}.");
      notifyListeners();
    }
  }

  void sellInvestment(Investment asset, double unitsToSell) {
    var existingIdx = character.investments.indexWhere((inv) => inv.name == asset.name);
    if (existingIdx != -1) {
      var investment = character.investments[existingIdx];
      if (investment.units >= unitsToSell) {
        investment.units -= unitsToSell;
        character.money += asset.price * unitsToSell;
        logActivity("Sold $unitsToSell units of ${asset.name}.");
        if (investment.units < 0.01) character.investments.removeAt(existingIdx);
        notifyListeners();
      }
    }
  }
  
  void buyProperty(Property property) {
      if (character.money >= property.price) {
          character.money -= property.price;
          addExpense(property.price);
          character.properties.add(property);
          logActivity("Successfully purchased ${property.name}!");
          notifyListeners();
      }
  }

  void applyForJob(Job job) {
    character.currentJob = job;
    logActivity("Congratulations! You are now a ${job.title}.");
    notifyListeners();
  }
}


class CEOJourneyApp extends StatelessWidget {
  const CEOJourneyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CEO Journey',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple, brightness: Brightness.dark),
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardTheme: CardThemeData(elevation: 4, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))
      ),
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final GameState _gameState = GameState();

  @override
  void initState() {
    super.initState();
    _gameState.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _gameState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CEO Journey Dashboard", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _buildDashboard(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _gameState.nextWeek(),
        tooltip: 'Next Week',
        child: const Icon(Icons.arrow_forward),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildDashboard() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        _buildProfileCard(),
        const SizedBox(height: 20),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildNavCard(context, "Karir", Icons.work, () => Navigator.push(context, MaterialPageRoute(builder: (_) => JobScreen(gameState: _gameState)))),
            _buildNavCard(context, "Investasi", Icons.trending_up, () => Navigator.push(context, MaterialPageRoute(builder: (_) => InvestmentScreen(gameState: _gameState)))),
            _buildNavCard(context, "Belanja", Icons.shopping_cart, () => Navigator.push(context, MaterialPageRoute(builder: (_) => ShopScreen(gameState: _gameState)))),
            _buildNavCard(context, "Aktivitas", Icons.article, () => Navigator.push(context, MaterialPageRoute(builder: (_) => ActivityScreen(gameState: _gameState)))),
          ],
        ),
      ],
    );
  }

  Widget _buildNavCard(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Theme.of(context).colorScheme.secondary),
            const SizedBox(height: 8),
            Text(title, style: Theme.of(context).textTheme.titleMedium)
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    var char = _gameState.character;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Usia: ${char.age} (Minggu: ${char.week})", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
             _buildStatBar(Icons.favorite, "Kesehatan", char.health, Colors.red),
             _buildStatBar(Icons.restaurant, "Kenyang", char.hunger, Colors.orange),
             _buildStatBar(Icons.sentiment_satisfied, "Mood", char.mood, Colors.blue),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            Text("Uang Tunai: Rp ${char.money.toStringAsFixed(0)}", style: Theme.of(context).textTheme.titleMedium),
             Text("Pekerjaan: ${char.currentJob?.title ?? 'Pengangguran'}"),

          ],
        ),
      ),
    );
  }

  Widget _buildStatBar(IconData icon, String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: value / 100,
              backgroundColor: color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

// --- SCREENS --- //

class JobScreen extends StatelessWidget {
  final GameState gameState;
  const JobScreen({super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Papan Karir")),
      body: AnimatedBuilder(
        animation: gameState,
        builder: (context, child) {
          return ListView.builder(
            itemCount: gameState._jobBoard.length,
            itemBuilder: (context, index) {
              var job = gameState._jobBoard[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: ListTile(
                  title: Text(job.title),
                  subtitle: Text("${job.sector} - Gaji: Rp ${job.salary.toStringAsFixed(0)}/minggu"),
                  trailing: ElevatedButton(
                    child: const Text("Lamar"),
                    onPressed: () {
                      gameState.applyForJob(job);
                      Navigator.pop(context);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class InvestmentScreen extends StatelessWidget {
    final GameState gameState;
    const InvestmentScreen({super.key, required this.gameState});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: const Text("Pasar Investasi")),
            body: AnimatedBuilder(
                animation: gameState,
                builder: (context, child) {
                    return ListView.builder(
                        itemCount: gameState._investmentMarket.length,
                        itemBuilder: (context, index) {
                            var asset = gameState._investmentMarket[index];
                            var ownedAsset = gameState.character.investments.firstWhere((inv) => inv.name == asset.name, orElse: () => Investment(name: "", price: 0, units: 0));
                            final TextEditingController buyController = TextEditingController();
                            final TextEditingController sellController = TextEditingController();

                            return Card(
                                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                child: ExpansionTile(
                                    title: Text(asset.name, style: Theme.of(context).textTheme.titleMedium),
                                    subtitle: Text("Harga: Rp ${asset.price.toStringAsFixed(0)}\nDimiliki: ${ownedAsset.units.toStringAsFixed(2)} unit"),
                                    children: [
                                        Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                                children: [
                                                    Row(children: [
                                                        Expanded(child: TextField(controller: buyController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: "Jumlah Beli"))),
                                                        IconButton(icon: Icon(Icons.shopping_cart), onPressed: () => gameState.buyInvestment(asset, double.tryParse(buyController.text) ?? 0)),
                                                    ]),
                                                    Row(children: [
                                                        Expanded(child: TextField(controller: sellController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: "Jumlah Jual"))),
                                                        IconButton(icon: Icon(Icons.sell), onPressed: () => gameState.sellInvestment(asset, double.tryParse(sellController.text) ?? 0)),
                                                    ]),
                                                ],
                                            ),
                                        )
                                    ],
                                ),
                            );
                        },
                    );
                },
            ),
        );
    }
}

class ShopScreen extends StatelessWidget {
  final GameState gameState;
  const ShopScreen({super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pusat Belanja")),
      body: AnimatedBuilder(
        animation: gameState,
        builder: (context, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text("Kebutuhan Pokok", style: Theme.of(context).textTheme.headlineSmall),
              ...gameState._foodMarket.map((food) => Card(
                child: ListTile(
                  title: Text(food.name),
                  subtitle: Text("Harga: Rp ${food.price.toStringAsFixed(0)}"),
                  trailing: ElevatedButton(onPressed: () => gameState.buyFood(food), child: const Text("Beli")),
                ),
              )),
              const SizedBox(height: 24),
              Text("Properti", style: Theme.of(context).textTheme.headlineSmall),
               ...gameState._propertyMarket.map((prop) => Card(
                child: ListTile(
                  title: Text(prop.name),
                  subtitle: Text("Harga: Rp ${prop.price.toStringAsFixed(0)}\nPendapatan: Rp ${prop.weeklyIncome.toStringAsFixed(0)}/minggu"),
                  trailing: ElevatedButton(onPressed: () => gameState.buyProperty(prop), child: const Text("Beli")),
                ),
              )),
            ],
          );
        },
      ),
    );
  }
}

class ActivityScreen extends StatelessWidget {
  final GameState gameState;
  const ActivityScreen({super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Log & Berita")),
      body: AnimatedBuilder(
        animation: gameState,
        builder: (context, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text("Berita Minggu Ini", style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(gameState.weeklyNews),
              const Divider(height: 40),
              Text("Log Aktivitas", style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              ...gameState.activityLog.map((log) => Text(log, style: const TextStyle(fontSize: 12, color: Colors.grey))),
            ],
          );
        },
      ),
    );
  }
}