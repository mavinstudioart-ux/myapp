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
  double money = 5000000; // Uang tunai

  BankAccount bankAccount = BankAccount();
  List<Business> businesses = [];
  
  double health = 100;
  double hunger = 100;
  double mood = 70;
  
  Job? currentJob;
  Education? currentEducation;
  int educationWeeksLeft = 0;
  
  List<Property> properties = [];
  List<Investment> investments = [];
  List<String> skills = ["SMA"];

  bool isStudying() => educationWeeksLeft > 0;

  double get netWorth {
      double assetValue = money + bankAccount.savings;
      assetValue += properties.fold(0, (prev, p) => prev + p.price);
      assetValue += investments.fold(0, (prev, i) => prev + (i.price * i.units));
      assetValue += businesses.fold(0, (prev, b) => prev + b.capitalCost);
      return assetValue - bankAccount.loan;
  }

  void reset() {
    name = "Player";
    age = 18;
    week = 1;
    money = 5000000;
    health = 100;
    hunger = 100;
    mood = 70;
    currentJob = null;
    currentEducation = null;
    educationWeeksLeft = 0;
    properties.clear();
    investments.clear();
    businesses.clear();
    bankAccount.reset();
    skills = ["SMA"];
  }
}

class BankAccount {
  double savings = 0;
  double loan = 0;
  static const double savingsInterestRate = 0.005; // 0.5% per week
  static const double loanInterestRate = 0.015; // 1.5% per week

  void reset(){
    savings = 0;
    loan = 0;
  }
}

class Business {
    final String name;
    final String sector;
    final double capitalCost;
    final double weeklyOperatingCost;
    final double baseWeeklyRevenue;
    final double volatility; // e.g., 0.2 for 20% variance

    Business({ required this.name, required this.sector, required this.capitalCost, required this.weeklyOperatingCost, required this.baseWeeklyRevenue, required this.volatility });

    double calculateWeeklyRevenue() {
        final randomFactor = (Random().nextDouble() * 2 - 1) * volatility;
        return baseWeeklyRevenue * (1 + randomFactor);
    }
}

class Job { final String title; final String sector; final double salary; final String requiredSkill; Job({required this.title, required this.sector, required this.salary, required this.requiredSkill}); }
class Education { final String name; final String description; final int durationInWeeks; final double cost; final String skillAwarded; final String requiredSkill; Education({required this.name, required this.description, required this.durationInWeeks, required this.cost, required this.skillAwarded, this.requiredSkill = "SMA"}); }
class Property { final String name; final double price; final double weeklyIncome; Property({required this.name, required this.price, required this.weeklyIncome}); }
class Investment { final String name; double price; double units; Investment({required this.name, required this.price, this.units = 0}); }
class Food { final String name; final double price; final double healthBonus; final double moodBonus; Food({required this.name, required this.price, required this.healthBonus, required this.moodBonus}); }

// -- GAME STATE MANAGEMENT --

class GameState extends ChangeNotifier {
  Character character = Character();
  List<String> activityLog = [];
  String weeklyNews = "";
  bool isGameOver = false;
  bool gameStarted = false;

  final List<Job> _jobBoard = [];
  final List<Education> _educationPrograms = [ Education(name: "D3 Teknik Informatika", description: "Diploma 3 tahun, setara 156 minggu.", durationInWeeks: 156, cost: 15000000, skillAwarded: "D3 TI", requiredSkill: "SMA"), Education(name: "S1 Manajemen Bisnis", description: "Sarjana 4 tahun, setara 208 minggu.", durationInWeeks: 208, cost: 40000000, skillAwarded: "S1 Bisnis", requiredSkill: "SMA"), Education(name: "S2 Magister Manajemen", description: "Magister 2 tahun, setara 104 minggu.", durationInWeeks: 104, cost: 50000000, skillAwarded: "S2 Manajemen", requiredSkill: "S1 Bisnis") ];
  final List<Business> _businessMarket = [ Business(name: "Warung Kopi", sector: "F&B", capitalCost: 25000000, weeklyOperatingCost: 1000000, baseWeeklyRevenue: 1500000, volatility: 0.3), Business(name: "Jasa Cuci Motor", sector: "Jasa", capitalCost: 15000000, weeklyOperatingCost: 500000, baseWeeklyRevenue: 750000, volatility: 0.2), Business(name: "Startup Aplikasi Mobile", sector: "Teknologi", capitalCost: 250000000, weeklyOperatingCost: 10000000, baseWeeklyRevenue: 12000000, volatility: 0.8) ];
  final List<Investment> _investmentMarket = [Investment(name: "Tech Stock (BCAC)", price: 5000), Investment(name: "Crypto (BTCF)", price: 500000000), Investment(name: "Gold", price: 1000000)];
  final List<Food> _foodMarket = [Food(name: "Instant Noodles", price: 50000, healthBonus: -5, moodBonus: -5), Food(name: "Warteg Rice", price: 150000, healthBonus: 5, moodBonus: 3), Food(name: "Healthy Catering", price: 400000, healthBonus: 10, moodBonus: 5)];
  final List<Property> _propertyMarket = [Property(name: "Studio Apartment", price: 300000000, weeklyIncome: 1500000), Property(name: "Cluster House", price: 750000000, weeklyIncome: 4000000)];


  void startNewGame(String playerName) { character.reset(); character.name = playerName; isGameOver = false; gameStarted = true; activityLog = ["Welcome to CEO Journey, ${character.name}! Anda memulai dengan ijazah SMA."]; weeklyNews = "No important news this week."; _generateJobs(); notifyListeners(); }
  void _generateJobs() { _jobBoard.clear(); _jobBoard.addAll([ Job(title: "Kasir Toko", sector: "Retail", salary: 800000, requiredSkill: "SMA"), Job(title: "Staf Admin", sector: "Kantoran", salary: 1000000, requiredSkill: "SMA"), Job(title: "Junior Programmer", sector: "Teknologi", salary: 2500000, requiredSkill: "D3 TI"), Job(title: "Manajer Pemasaran", sector: "Bisnis", salary: 5000000, requiredSkill: "S1 Bisnis"), Job(title: "Direktur Keuangan", sector: "Korporat", salary: 15000000, requiredSkill: "S2 Manajemen") ]); }

  void nextWeek() {
    if (isGameOver) return;
    character.week++;

    if (character.isStudying()) {
      character.educationWeeksLeft--;
      logActivity("Belajar untuk ${character.currentEducation!.name}. Sisa ${character.educationWeeksLeft} minggu.");
      if (character.educationWeeksLeft <= 0) {
        String skill = character.currentEducation!.skillAwarded;
        character.skills.add(skill);
        logActivity("Selamat! Anda telah menyelesaikan ${character.currentEducation!.name} dan mendapatkan: $skill!");
        character.currentEducation = null;
      }
    }

    double totalIncome = 0;
    if (character.currentJob != null && !character.isStudying()) { totalIncome += character.currentJob!.salary; }
    for (var prop in character.properties) { totalIncome += prop.weeklyIncome; }

    if(character.bankAccount.savings > 0) { double interest = character.bankAccount.savings * BankAccount.savingsInterestRate; character.bankAccount.savings += interest; logActivity("Bunga tabungan diterima: Rp ${interest.toStringAsFixed(0)}"); }
    if(character.bankAccount.loan > 0) { double interest = character.bankAccount.loan * BankAccount.loanInterestRate; character.bankAccount.loan += interest; logActivity("Bunga pinjaman ditambahkan: Rp ${interest.toStringAsFixed(0)}"); }

    for (var biz in character.businesses) {
        double revenue = biz.calculateWeeklyRevenue();
        double profit = revenue - biz.weeklyOperatingCost;
        character.money += profit;
        logActivity(profit >= 0 ? "Bisnis ${biz.name} menghasilkan profit: Rp ${profit.toStringAsFixed(0)}" : "Bisnis ${biz.name} mengalami kerugian: Rp ${profit.abs().toStringAsFixed(0)}");
    }
    
    character.money += totalIncome;
    if(totalIncome > 0) logActivity("Total pendapatan pasif & gaji: Rp ${totalIncome.toStringAsFixed(0)}");

    character.hunger = max(0, character.hunger - 7);
    character.mood = max(0, character.mood - 3);
    if (character.hunger < 20) { character.health = max(0, character.health - 10); character.mood = max(0, character.mood - 5); logActivity("Sangat lapar! Kesehatan & mood menurun drastis."); }
    if (character.health <= 0) { logActivity("Kesehatan habis. Perjalananmu berakhir."); isGameOver = true; notifyListeners(); return; }
    if (character.week % 52 == 0) { character.age++; logActivity("Selamat ulang tahun ke-${character.age}!"); }
    if (character.week % 8 == 0) _generateJobs();

    notifyListeners();
  }

  void logActivity(String message) { activityLog.insert(0, "[${character.age}th, W${character.week}] $message"); if (activityLog.length > 100) activityLog.removeLast(); notifyListeners(); }
  void applyForJob(Job job) { if (character.skills.contains(job.requiredSkill)) { character.currentJob = job; logActivity("Selamat! Anda sekarang adalah ${job.title}."); notifyListeners(); } else { logActivity("Syarat tidak terpenuhi: ${job.requiredSkill}"); } }
  void enrollInEducation(Education course) { if (character.money >= course.cost && !character.isStudying()) { if(character.skills.contains(course.requiredSkill)){ character.money -= course.cost; character.currentEducation = course; character.educationWeeksLeft = course.durationInWeeks; character.currentJob = null; logActivity("Mendaftar di ${course.name}. Biaya: Rp ${course.cost.toStringAsFixed(0)}"); notifyListeners(); } else { logActivity("Prasyarat tidak terpenuhi: Anda memerlukan ${course.requiredSkill}."); } } else if (character.isStudying()){ logActivity("Anda sudah terdaftar di suatu program pendidikan."); } else { logActivity("Uang tidak cukup untuk mendaftar."); } }
  void buyFood(Food food) { if (character.money >= food.price) { character.money -= food.price; character.hunger = min(100, character.hunger + 40); character.health = min(100, character.health + food.healthBonus); character.mood = min(100, character.mood + food.moodBonus); logActivity("Membeli '${food.name}'."); notifyListeners(); } }
  void buyProperty(Property prop) { if(character.money >= prop.price) { character.money -= prop.price; character.properties.add(prop); logActivity("Membeli properti: ${prop.name}."); notifyListeners(); } }
  void buyInvestment(Investment asset, double units) { double cost = asset.price * units; if (character.money >= cost) { character.money -= cost; var existing = character.investments.indexWhere((i) => i.name == asset.name); if (existing != -1) { character.investments[existing].units += units; } else { character.investments.add(Investment(name: asset.name, price: asset.price, units: units)); } logActivity("Membeli $units unit ${asset.name}."); notifyListeners(); } }
  void sellInvestment(Investment asset, double units) { var existingIdx = character.investments.indexWhere((i) => i.name == asset.name); if (existingIdx != -1) { var owned = character.investments[existingIdx]; if (owned.units >= units) { owned.units -= units; character.money += asset.price * units; if (owned.units < 0.01) character.investments.removeAt(existingIdx); logActivity("Menjual $units unit ${asset.name}."); notifyListeners(); } } }
  void startBusiness(Business biz) { if(character.money >= biz.capitalCost) { character.money -= biz.capitalCost; character.businesses.add(biz); logActivity("Selamat! Anda telah memulai bisnis: ${biz.name}."); notifyListeners(); } else { logActivity("Modal tidak cukup untuk memulai ${biz.name}."); } }

  void deposit(double amount) { if(character.money >= amount) { character.money -= amount; character.bankAccount.savings += amount; logActivity("Menabung Rp ${amount.toStringAsFixed(0)} ke bank."); notifyListeners(); } }
  void withdraw(double amount) { if(character.bankAccount.savings >= amount) { character.bankAccount.savings -= amount; character.money += amount; logActivity("Menarik Rp ${amount.toStringAsFixed(0)} dari bank."); notifyListeners(); } }
  void takeLoan(double amount) { double maxLoan = character.netWorth * 2; if(character.bankAccount.loan + amount <= maxLoan) { character.bankAccount.loan += amount; character.money += amount; logActivity("Mengambil pinjaman Rp ${amount.toStringAsFixed(0)}."); notifyListeners(); } else { logActivity("Melebihi batas pinjaman maksimal Anda."); } }
  void repayLoan(double amount) { if(character.money >= amount) { double repayment = min(amount, character.bankAccount.loan); character.money -= repayment; character.bankAccount.loan -= repayment; logActivity("Membayar pinjaman Rp ${repayment.toStringAsFixed(0)}."); notifyListeners(); } }
}

class CEOJourneyApp extends StatelessWidget { const CEOJourneyApp({super.key}); @override Widget build(BuildContext context) { return MaterialApp(title: 'CEO Journey', theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark), scaffoldBackgroundColor: const Color(0xFF121212), cardTheme: CardThemeData(elevation: 4, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))), home: const MainMenuScreen()); } }

// --- MENU & SETUP SCREENS ---

class MainMenuScreen extends StatelessWidget { const MainMenuScreen({super.key}); @override Widget build(BuildContext context) { return Scaffold(body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[Text('CEO Journey', style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)), const SizedBox(height: 50), ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CharacterCreationScreen())), child: const Text('Permainan Baru')), const SizedBox(height: 20), AnimatedBuilder(animation: gameState, builder: (context, child) { return ElevatedButton(onPressed: gameState.gameStarted && !gameState.isGameOver ? () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const GameScreen())) : null, child: const Text('Lanjutkan')); }), const SizedBox(height: 20), ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade800), child: const Text('Pengaturan'))]))); } }

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
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Nama Karakter", border: OutlineInputBorder()), onSubmitted: (_) => _startGame()),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startGame,
              child: const Text("Mulai Petualangan"),
            ),
          ],
        ),
      ),
    );
  }
}

// --- GAMEPLAY SCREENS ---

class GameScreen extends StatefulWidget { const GameScreen({super.key}); @override State<GameScreen> createState() => _GameScreenState(); }
class _GameScreenState extends State<GameScreen> { @override void initState() { super.initState(); gameState.addListener(_onGameStateChanged); } @override void dispose() { gameState.removeListener(_onGameStateChanged); super.dispose(); } void _onGameStateChanged() { if (mounted) { setState(() {}); if (gameState.isGameOver) { showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) { return AlertDialog(title: const Text('Game Over'), content: Text('Perjalanan ${gameState.character.name} telah berakhir.'), actions: <Widget>[TextButton(onPressed: () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const MainMenuScreen()), (route) => false), child: const Text('Kembali ke Menu'))]); }); } } } @override Widget build(BuildContext context) { return Scaffold(appBar: AppBar(title: Text("${gameState.character.name}'s Journey"), backgroundColor: Colors.transparent, elevation: 0, actions: [IconButton(icon: const Icon(Icons.history), tooltip: "Log Aktivitas", onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ActivityScreen())))]), body: _buildDashboard(), floatingActionButton: FloatingActionButton(onPressed: () => gameState.nextWeek(), tooltip: 'Next Week', child: const Icon(Icons.arrow_forward))); } Widget _buildDashboard() { return ListView(padding: const EdgeInsets.symmetric(horizontal: 16.0), children: [_buildProfileCard(), const SizedBox(height: 20), GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisSpacing: 16, mainAxisSpacing: 16, children: [_buildNavCard(context, "Karir", Icons.work, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const JobScreen()))), _buildNavCard(context, "Pendidikan", Icons.school, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EducationScreen()))), _buildNavCard(context, "Bank", Icons.account_balance, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BankScreen()))), _buildNavCard(context, "Bisnis", Icons.business, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BusinessScreen()))), _buildNavCard(context, "Investasi", Icons.trending_up, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InvestmentScreen()))), _buildNavCard(context, "Belanja", Icons.shopping_cart, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ShopScreen()))) ])]); } Widget _buildNavCard(BuildContext context, String title, IconData icon, VoidCallback onTap) { return InkWell(onTap: onTap, borderRadius: BorderRadius.circular(12), child: Card(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 40, color: Theme.of(context).colorScheme.secondary), const SizedBox(height: 8), Text(title, style: Theme.of(context).textTheme.titleMedium)]))); } Widget _buildProfileCard() { var char = gameState.character; return Card(child: Padding(padding: const EdgeInsets.all(16.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Usia: ${char.age} (Minggu: ${char.week})", style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: 12), _buildStatBar(Icons.favorite, "Kesehatan", char.health, Colors.red), _buildStatBar(Icons.restaurant, "Kenyang", char.hunger, Colors.orange), _buildStatBar(Icons.sentiment_satisfied, "Mood", char.mood, Colors.blue), const SizedBox(height: 12), const Divider(), const SizedBox(height: 12), Text("Kekayaan Bersih: Rp ${char.netWorth.toStringAsFixed(0)}", style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: 4), Text("Tunai: Rp ${char.money.toStringAsFixed(0)}"), Text("Tabungan: Rp ${char.bankAccount.savings.toStringAsFixed(0)}"), Text("Pinjaman: Rp ${char.bankAccount.loan.toStringAsFixed(0)}", style: const TextStyle(color: Colors.redAccent)), const SizedBox(height: 8), Text(char.isStudying() ? "Belajar: ${char.currentEducation!.name}" : "Pekerjaan: ${char.currentJob?.title ?? 'Pengangguran'}"), const SizedBox(height: 8), Text("Keahlian: ${char.skills.join(', ')}", overflow: TextOverflow.ellipsis)]))); } Widget _buildStatBar(IconData icon, String label, double value, Color color) { return Padding(padding: const EdgeInsets.symmetric(vertical: 4.0), child: Row(children: [Icon(icon, color: color, size: 20), const SizedBox(width: 8), SizedBox(width: 70, child: Text(label, style: const TextStyle(fontSize: 14))), Expanded(child: LinearProgressIndicator(value: value / 100, backgroundColor: color.withAlpha(51), valueColor: AlwaysStoppedAnimation<Color>(color))), const SizedBox(width: 8), SizedBox(width: 40, child: Text("${value.toStringAsFixed(0)}%"))])); } }

class BankScreen extends StatelessWidget { const BankScreen({super.key}); @override Widget build(BuildContext context) { final amountController = TextEditingController(); return Scaffold(appBar: AppBar(title: const Text("Bank")), body: AnimatedBuilder(animation: gameState, builder: (context, child) { return ListView(padding: const EdgeInsets.all(16), children: [ Text("Rekening Anda", style: Theme.of(context).textTheme.headlineSmall), const SizedBox(height: 8), Text("Tabungan: Rp ${gameState.character.bankAccount.savings.toStringAsFixed(0)}"), Text("Pinjaman: Rp ${gameState.character.bankAccount.loan.toStringAsFixed(0)}"), Text("Batas Pinjaman: Rp ${(gameState.character.netWorth * 2).toStringAsFixed(0)}"), const Divider(height: 30), TextField(controller: amountController, decoration: const InputDecoration(labelText: "Jumlah", border: OutlineInputBorder()), keyboardType: const TextInputType.numberWithOptions(decimal: true)), const SizedBox(height: 16), Wrap(spacing: 8, runSpacing: 8, children: [ ElevatedButton(onPressed: () { final amount = double.tryParse(amountController.text) ?? 0; gameState.deposit(amount); amountController.clear(); }, child: const Text("Deposit")), ElevatedButton(onPressed: () { final amount = double.tryParse(amountController.text) ?? 0; gameState.withdraw(amount); amountController.clear(); }, child: const Text("Withdraw")), ElevatedButton(onPressed: () { final amount = double.tryParse(amountController.text) ?? 0; gameState.takeLoan(amount); amountController.clear(); }, child: const Text("Take Loan")), ElevatedButton(onPressed: () { final amount = double.tryParse(amountController.text) ?? 0; gameState.repayLoan(amount); amountController.clear(); }, child: const Text("Repay Loan")) ]) ]); })); } }
class BusinessScreen extends StatelessWidget { const BusinessScreen({super.key}); @override Widget build(BuildContext context) { return DefaultTabController(length: 2, child: Scaffold(appBar: AppBar(title: const Text("Manajemen Bisnis"), bottom: const TabBar(tabs: [Tab(text: "Beli Bisnis"), Tab(text: "Bisnis Saya")])), body: AnimatedBuilder(animation: gameState, builder: (context, child) { return TabBarView(children: [ ListView.builder(itemCount: gameState._businessMarket.length, itemBuilder: (context, index) { var biz = gameState._businessMarket[index]; bool canBuy = gameState.character.money >= biz.capitalCost; return Card(margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6), child: ListTile(title: Text(biz.name), subtitle: Text("Modal: Rp ${biz.capitalCost.toStringAsFixed(0)}\nPotensi Profit/Minggu: Rp ${(biz.baseWeeklyRevenue - biz.weeklyOperatingCost).toStringAsFixed(0)}"), trailing: ElevatedButton(onPressed: canBuy ? () => gameState.startBusiness(biz) : null, child: const Text("Beli")))); }), gameState.character.businesses.isEmpty ? const Center(child: Text("Anda belum memiliki bisnis.")) : ListView.builder(itemCount: gameState.character.businesses.length, itemBuilder: (context, index) { var biz = gameState.character.businesses[index]; return Card(margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6), child: ListTile(title: Text(biz.name), subtitle: Text("Sektor: ${biz.sector}\nBiaya Operasional: Rp ${biz.weeklyOperatingCost.toStringAsFixed(0)}/minggu"))); }) ]); }))); } }
class JobScreen extends StatelessWidget { const JobScreen({super.key}); @override Widget build(BuildContext context) { return Scaffold(appBar: AppBar(title: const Text("Papan Karir")), body: AnimatedBuilder(animation: gameState, builder: (context, child) { return ListView.builder(itemCount: gameState._jobBoard.length, itemBuilder: (context, index) { var job = gameState._jobBoard[index]; bool canApply = gameState.character.skills.contains(job.requiredSkill); return Card(margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6), child: ListTile(title: Text(job.title), subtitle: Text("${job.sector} - Gaji: Rp ${job.salary.toStringAsFixed(0)}/minggu\nSyarat: ${job.requiredSkill}"), trailing: ElevatedButton(onPressed: canApply && !gameState.character.isStudying() ? () { gameState.applyForJob(job); if (Navigator.canPop(context)) Navigator.pop(context); } : null, child: const Text("Lamar")))); }); })); } }
class EducationScreen extends StatelessWidget { const EducationScreen({super.key}); @override Widget build(BuildContext context) { return Scaffold(appBar: AppBar(title: const Text("Pusat Pendidikan")), body: AnimatedBuilder(animation: gameState, builder: (context, child) { return ListView.builder(itemCount: gameState._educationPrograms.length, itemBuilder: (context, index) { var course = gameState._educationPrograms[index]; bool canEnroll = gameState.character.money >= course.cost && !gameState.character.isStudying() && gameState.character.skills.contains(course.requiredSkill); bool hasSkill = gameState.character.skills.contains(course.skillAwarded); String buttonText = hasSkill ? "Selesai" : (gameState.character.isStudying() ? "Sedang Belajar" : "Daftar"); return Card(margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6), child: ListTile(title: Text(course.name), subtitle: Text("${course.description}\nBiaya: Rp ${course.cost.toStringAsFixed(0)}"), trailing: ElevatedButton(onPressed: hasSkill || !canEnroll ? null : () => gameState.enrollInEducation(course), child: Text(buttonText)))); }); })); } }
class InvestmentScreen extends StatelessWidget { const InvestmentScreen({super.key}); @override Widget build(BuildContext context) { final amountController = TextEditingController(); return Scaffold(appBar: AppBar(title: const Text("Pasar Investasi")), body: AnimatedBuilder(animation: gameState, builder: (context, child) { return ListView.builder(itemCount: gameState._investmentMarket.length, itemBuilder: (context, index) { var asset = gameState._investmentMarket[index]; var ownedAsset = gameState.character.investments.firstWhere((inv) => inv.name == asset.name, orElse: () => Investment(name: "", price: 0, units: 0)); return Card(margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6), child: ExpansionTile(title: Text(asset.name), subtitle: Text("Harga: Rp ${asset.price.toStringAsFixed(0)}\nDimiliki: ${ownedAsset.units.toStringAsFixed(2)} unit"), children: [ Padding(padding: const EdgeInsets.all(16), child: Column(children: [ TextField(controller: amountController, decoration: const InputDecoration(labelText: "Jumlah Unit", border: OutlineInputBorder()), keyboardType: const TextInputType.numberWithOptions(decimal: true)), const SizedBox(height: 16), Wrap(spacing: 8, children: [ ElevatedButton(onPressed: () { final amount = double.tryParse(amountController.text) ?? 0; gameState.buyInvestment(asset, amount); amountController.clear(); }, child: const Text("Beli")), ElevatedButton(onPressed: () { final amount = double.tryParse(amountController.text) ?? 0; gameState.sellInvestment(asset, amount); amountController.clear(); }, child: const Text("Jual")) ]) ])) ])); }); })); } }
class ShopScreen extends StatelessWidget { const ShopScreen({super.key}); @override Widget build(BuildContext context) { return Scaffold(appBar: AppBar(title: const Text("Pusat Belanja")), body: AnimatedBuilder(animation: gameState, builder: (context, child) { return ListView(padding: const EdgeInsets.all(16), children: [ Text("Kebutuhan Pokok", style: Theme.of(context).textTheme.headlineSmall), ...gameState._foodMarket.map((food) => Card(child: ListTile(title: Text(food.name), subtitle: Text("Harga: Rp ${food.price.toStringAsFixed(0)}\n+${food.healthBonus} Kesehatan, +${food.moodBonus} Mood"), trailing: ElevatedButton(onPressed: () => gameState.buyFood(food), child: const Text("Beli"))))), const SizedBox(height: 24), Text("Properti", style: Theme.of(context).textTheme.headlineSmall), ...gameState._propertyMarket.map((prop) => Card(child: ListTile(title: Text(prop.name), subtitle: Text("Harga: Rp ${prop.price.toStringAsFixed(0)}\nPendapatan: Rp ${prop.weeklyIncome.toStringAsFixed(0)}/minggu"), trailing: ElevatedButton(onPressed: () => gameState.buyProperty(prop), child: const Text("Beli"))))) ]); })); } }
class ActivityScreen extends StatelessWidget { const ActivityScreen({super.key}); @override Widget build(BuildContext context) { return Scaffold(appBar: AppBar(title: const Text("Log Aktivitas")), body: AnimatedBuilder(animation: gameState, builder: (context, child) { return ListView(padding: const EdgeInsets.all(16), children: [ ...gameState.activityLog.map((log) => Padding(padding: const EdgeInsets.symmetric(vertical: 4.0), child: Text(log, style: const TextStyle(fontSize: 12, color: Colors.white70)))) ]); })); } }