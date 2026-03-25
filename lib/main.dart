import 'package:flutter/material.dart';
import 'dart:math';

// -- Global Game State --
GameState gameState = GameState();

void main() {
  runApp(const CEOJourneyApp());
}

// -- DATA MODELS --

class Character {
  String name = "Player";
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

  void reset() {
    name = "Player";
    age = 18;
    week = 1;
    money = 5000000;
    health = 100;
    hunger = 100;
    mood = 70;
    currentJob = null;
    properties.clear();
    investments.clear();
    skills.clear();
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
  List<String> activityLog = [];
  String weeklyNews = "";
  bool isGameOver = false;
  bool gameStarted = false;

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

  void startNewGame(String playerName) {
    character.reset();
    character.name = playerName;
    isGameOver = false;
    gameStarted = true;
    activityLog = ["Welcome to CEO Journey, ${character.name}!"];
    weeklyNews = "No important news this week.";
    _generateJobs();
    notifyListeners();
  }

  void _generateJobs() {
    _jobBoard.clear();
    _jobBoard.addAll([
      Job(title: "Cashier", sector: "Retail", salary: 800000),
      Job(title: "Junior Programmer", sector: "Tech", salary: 1500000),
      Job(title: "Graphic Designer Intern", sector: "Creative", salary: 700000),
    ]);
  }

  void nextWeek() {
    if (isGameOver) return;

    character.week++;

    if (character.week % 52 == 0) {
      character.age++;
      logActivity("Happy ${character.age}th birthday!");
    }

    character.hunger = max(0, character.hunger - 5);
    if (character.hunger < 20) {
      character.health = max(0, character.health - 10);
      character.mood = max(0, character.mood - 5);
      logActivity("You are very hungry! Health and mood are decreasing rapidly.");
    }
    
    if (character.health <= 0) {
      logActivity("Your health has reached zero. Your journey has ended.");
      isGameOver = true;
      notifyListeners();
      return;
    }

    if (character.currentJob != null) {
      character.money += character.currentJob!.salary;
      logActivity("Salary received: Rp ${character.currentJob!.salary.toStringAsFixed(0)}");
    }

    for (var prop in character.properties) {
      character.money += prop.weeklyIncome;
    }

    if (character.week % 4 == 0) _generateJobs();

    notifyListeners();
  }

  void logActivity(String message) {
    activityLog.insert(0, "[Age ${character.age}, W${character.week}] $message");
    if (activityLog.length > 30) activityLog.removeLast();
    notifyListeners();
  }

  void applyForJob(Job job) {
    character.currentJob = job;
    logActivity("Congratulations! You are now a ${job.title}.");
    notifyListeners();
  }
  
  void buyFood(Food food) {
    if (character.money >= food.price) {
      character.money -= food.price;
      character.hunger = min(100, character.hunger + 25);
      character.health = min(100, character.health + food.healthBonus);
      character.mood = min(100, character.mood + food.moodBonus);
      logActivity("Bought '${food.name}'.");
      notifyListeners();
    }
  }

  void buyProperty(Property property) {
    if (character.money >= property.price) {
      character.money -= property.price;
      character.properties.add(property);
      logActivity("Purchased ${property.name}.");
      notifyListeners();
    }
  }

  void buyInvestment(Investment asset, double units) {
    double cost = asset.price * units;
    if (character.money >= cost) {
      character.money -= cost;
      var existing = character.investments.indexWhere((i) => i.name == asset.name);
      if (existing != -1) {
        character.investments[existing].units += units;
      } else {
        character.investments.add(Investment(name: asset.name, price: asset.price, units: units));
      }
      logActivity("Bought $units units of ${asset.name}.");
      notifyListeners();
    }
  }

  void sellInvestment(Investment asset, double units) {
    var existingIdx = character.investments.indexWhere((i) => i.name == asset.name);
    if (existingIdx != -1) {
      var owned = character.investments[existingIdx];
      if (owned.units >= units) {
        owned.units -= units;
        character.money += asset.price * units;
        if (owned.units < 0.01) character.investments.removeAt(existingIdx);
        logActivity("Sold $units units of ${asset.name}.");
        notifyListeners();
      }
    }
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
        cardTheme: CardThemeData(elevation: 4, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
          )
        )
      ),
      home: const MainMenuScreen(),
    );
  }
}

// --- MENU & SETUP SCREENS ---

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('CEO Journey', style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 50),
            ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CharacterCreationScreen())), child: const Text('Permainan Baru')),
            const SizedBox(height: 20),
            AnimatedBuilder(
              animation: gameState,
              builder: (context, child) {
                return ElevatedButton(
                  onPressed: gameState.gameStarted && !gameState.isGameOver ? () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const GameScreen())) : null,
                  child: const Text('Lanjutkan'),
                );
              },
            ),
             const SizedBox(height: 20),
            ElevatedButton(onPressed: () { /* Placeholder for settings */ }, child: const Text('Pengaturan'), style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade800)),
          ],
        ),
      ),
    );
  }
}

class CharacterCreationScreen extends StatefulWidget {
  const CharacterCreationScreen({super.key});

  @override
  State<CharacterCreationScreen> createState() => _CharacterCreationScreenState();
}

class _CharacterCreationScreenState extends State<CharacterCreationScreen> {
  final _nameController = TextEditingController();

  void _startGame() {
    if (_nameController.text.isNotEmpty) {
      gameState.startNewGame(_nameController.text);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const GameScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buat Karakter"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Nama Karakter", border: OutlineInputBorder()),
              onSubmitted: (_) => _startGame(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _startGame, child: const Text("Mulai Petualangan")),
          ],
        ),
      ),
    );
  }
}

// --- GAMEPLAY SCREENS ---

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    super.initState();
    gameState.addListener(_onGameStateChanged);
  }

  @override
  void dispose() {
    gameState.removeListener(_onGameStateChanged);
    super.dispose();
  }

  void _onGameStateChanged() {
    if (mounted) {
      setState(() {});
      if (gameState.isGameOver) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Game Over'),
              content: Text('Perjalanan ${gameState.character.name} telah berakhir pada usia ${gameState.character.age}.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Kembali ke Menu Utama'),
                  onPressed: () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const MainMenuScreen()), (route) => false),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${gameState.character.name}'s Journey", style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _buildDashboard(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => gameState.nextWeek(),
        tooltip: 'Next Week',
        child: const Icon(Icons.arrow_forward),
      ),
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
            _buildNavCard(context, "Karir", Icons.work, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const JobScreen()))),
            _buildNavCard(context, "Investasi", Icons.trending_up, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InvestmentScreen()))),
            _buildNavCard(context, "Belanja", Icons.shopping_cart, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ShopScreen()))),
            _buildNavCard(context, "Aktivitas", Icons.article, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ActivityScreen()))),
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
    var char = gameState.character;
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
          SizedBox(width: 70, child: Text(label, style: const TextStyle(fontSize: 14))),
          Expanded(
            child: LinearProgressIndicator(
              value: value / 100,
              backgroundColor: color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(width: 40, child: Text("${value.toStringAsFixed(0)}%")),
        ],
      ),
    );
  }
}

class JobScreen extends StatelessWidget {
  const JobScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Papan Karir")),
      body: ListView.builder(
        itemCount: gameState._jobBoard.length,
        itemBuilder: (context, index) {
          var job = gameState._jobBoard[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: ListTile(
              title: Text(job.title),
              subtitle: Text("${job.sector} - Gaji: Rp ${job.salary.toStringAsFixed(0)}/minggu"),
              trailing: ElevatedButton(child: const Text("Lamar"), onPressed: () => gameState.applyForJob(job)),
            ),
          );
        },
      ),
    );
  }
}

class InvestmentScreen extends StatelessWidget {
  const InvestmentScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pasar Investasi")),
      body: ListView.builder(
        itemCount: gameState._investmentMarket.length,
        itemBuilder: (context, index) {
          var asset = gameState._investmentMarket[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: ListTile(
              title: Text(asset.name),
              subtitle: Text("Harga: Rp ${asset.price.toStringAsFixed(0)}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(icon: const Icon(Icons.remove), onPressed: () => gameState.sellInvestment(asset, 1)),
                  IconButton(icon: const Icon(Icons.add), onPressed: () => gameState.buyInvestment(asset, 1)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pusat Belanja")),
      body: ListView(
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
                  subtitle: Text("Harga: Rp ${prop.price.toStringAsFixed(0)}"),
                  trailing: ElevatedButton(onPressed: () => gameState.buyProperty(prop), child: const Text("Beli")),
                ),
              )),
        ],
      ),
    );
  }
}

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Log & Berita")),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text("Berita Minggu Ini", style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(gameState.weeklyNews),
        const Divider(height: 40),
        Text("Log Aktivitas", style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        ...gameState.activityLog.map((log) => Padding(padding: const EdgeInsets.symmetric(vertical: 2.0), child: Text(log, style: const TextStyle(fontSize: 12, color: Colors.grey)))),
      ]),
    );
  }
}