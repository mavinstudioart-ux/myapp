import 'dart:math';
import 'package:flutter/material.dart';
import 'models/models.dart';
import 'utils/utils.dart';

class GameState extends ChangeNotifier {
  Character character = Character();
  List<String> activityLog = [];
  String weeklyNews = "Berita minggu ini.";
  bool isGameOver = false;
  bool gameStarted = false;
  String? snackbarMessage;

  final List<Job> _jobBoard = [];
  final List<Education> _educationPrograms = [
    Education(name: "D3 Teknik Informatika", description: "Diploma 3 tahun, setara 156 minggu.", durationInWeeks: 156, cost: 15000000, skillAwarded: "D3 TI", requiredSkill: "SMA"),
    Education(name: "S1 Manajemen Bisnis", description: "Sarjana 4 tahun, setara 208 minggu.", durationInWeeks: 208, cost: 40000000, skillAwarded: "S1 Bisnis", requiredSkill: "SMA"),
    Education(name: "S2 Magister Manajemen", description: "Magister 2 tahun, setara 104 minggu.", durationInWeeks: 104, cost: 50000000, skillAwarded: "S2 Manajemen", requiredSkill: "S1 Bisnis"),
  ];
  final List<Business> _businessMarket = [
    Business(name: "Warung Kopi", sector: "F&B", capitalCost: 25000000, weeklyOperatingCost: 1000000, baseWeeklyRevenue: 1500000, volatility: 0.3),
    Business(name: "Jasa Cuci Motor", sector: "Jasa", capitalCost: 15000000, weeklyOperatingCost: 500000, baseWeeklyRevenue: 750000, volatility: 0.2),
    Business(name: "Startup Aplikasi Mobile", sector: "Teknologi", capitalCost: 250000000, weeklyOperatingCost: 10000000, baseWeeklyRevenue: 12000000, volatility: 0.8),
  ];
  final List<Investment> _investmentMarket = [Investment(name: "Saham Teknologi (BCAC)", price: 5000), Investment(name: "Kripto (BTCF)", price: 500000000), Investment(name: "Emas", price: 1000000)];
  final List<Food> _foodMarket = [Food(name: "Mie Instan", price: 50000, healthBonus: -5, moodBonus: -5), Food(name: "Nasi Warteg", price: 150000, healthBonus: 5, moodBonus: 3), Food(name: "Katering Sehat", price: 400000, healthBonus: 10, moodBonus: 5)];
  final List<Property> _propertyMarket = [Property(name: "Apartemen Studio", price: 300000000, weeklyIncome: 1500000), Property(name: "Rumah Cluster", price: 750000000, weeklyIncome: 4000000)];

  List<Job> get jobBoard => _jobBoard;
  List<Education> get educationPrograms => _educationPrograms;
  List<Business> get businessMarket => _businessMarket;
  List<Investment> get investmentMarket => _investmentMarket;
  List<Food> get foodMarket => _foodMarket;
  List<Property> get propertyMarket => _propertyMarket;
  double get maxLoanAmount => character.netWorth * 2;

  void setSnackbar(String message) {
    snackbarMessage = message;
    notifyListeners();
    snackbarMessage = null;
  }

  void startNewGame(String playerName) {
    character.reset();
    character.name = playerName;
    isGameOver = false;
    gameStarted = true;
    activityLog = ["Selamat datang di CEO Journey, ${character.name}! Anda memulai dengan ijazah SMA."];
    weeklyNews = "Tidak ada berita penting minggu ini.";
    _generateJobs();
    notifyListeners();
  }

  void _generateJobs() {
    _jobBoard.clear();
    _jobBoard.addAll([
      // Pekerjaan Tetap
      Job(title: "Kasir Toko", sector: "Retail", salary: 800000, requiredSkill: "SMA", jobType: JobType.permanent),
      Job(title: "Staf Admin", sector: "Kantoran", salary: 1000000, requiredSkill: "SMA", jobType: JobType.permanent),
      Job(title: "Junior Programmer", sector: "Teknologi", salary: 2500000, requiredSkill: "D3 TI", jobType: JobType.permanent),
      Job(title: "Manajer Pemasaran", sector: "Bisnis", salary: 5000000, requiredSkill: "S1 Bisnis", jobType: JobType.permanent),
      Job(title: "Direktur Keuangan", sector: "Korporat", salary: 15000000, requiredSkill: "S2 Manajemen", jobType: JobType.permanent),
      // Pekerjaan Freelance
      Job(title: "Entry Data Sederhana", sector: "Admin", payout: 400000, durationInWeeks: 2, requiredSkill: "SMA", jobType: JobType.freelance),
      Job(title: "Desain Logo UKM", sector: "Kreatif", payout: 1500000, durationInWeeks: 3, requiredSkill: "SMA", jobType: JobType.freelance),
      Job(title: "Buat Website Landing Page", sector: "Teknologi", payout: 5000000, durationInWeeks: 4, requiredSkill: "D3 TI", jobType: JobType.freelance),
      Job(title: "Riset Pasar Produk Baru", sector: "Bisnis", payout: 8000000, durationInWeeks: 6, requiredSkill: "S1 Bisnis", jobType: JobType.freelance),
    ]);
  }

  void nextWeek() {
    if (isGameOver) return;
    character.week++;

    // Proses Pendidikan
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

    // Proses Pekerjaan Lepas (Freelance)
    List<ActiveFreelanceJob> completedJobs = [];
    for (var freelanceJob in character.activeFreelanceJobs) {
      freelanceJob.weeksLeft--;
      if (freelanceJob.weeksLeft <= 0) {
        character.money += freelanceJob.job.payout!;
        logActivity("Proyek freelance '${freelanceJob.job.title}' selesai! Bayaran diterima: ${formatCurrency(freelanceJob.job.payout!)}");
        completedJobs.add(freelanceJob);
      }
    }
    character.activeFreelanceJobs.removeWhere((job) => completedJobs.contains(job));

    // Proses Pendapatan Mingguan
    double weeklyIncome = 0;
    if (character.currentJob != null && character.currentJob!.jobType == JobType.permanent) {
      weeklyIncome += character.currentJob!.salary!;
    }
    for (var prop in character.properties) {
      weeklyIncome += prop.weeklyIncome;
    }
    character.money += weeklyIncome;
    if (weeklyIncome > 0) logActivity("Pendapatan mingguan (gaji & properti): ${formatCurrency(weeklyIncome)}");

    // Proses Keuangan & Status Lainnya...
    if (character.bankAccount.savings > 0) {
      double interest = character.bankAccount.savings * character.bankAccount.savingsInterestRate;
      character.bankAccount.savings += interest;
      logActivity("Bunga tabungan diterima: ${formatCurrency(interest)}");
    }
    if (character.bankAccount.loan > 0) {
      double interest = character.bankAccount.loan * character.bankAccount.loanInterestRate;
      character.bankAccount.loan += interest;
      logActivity("Bunga pinjaman ditambahkan: ${formatCurrency(interest)}");
    }
    for (var biz in character.businesses) {
      double revenue = biz.calculateWeeklyRevenue();
      double profit = revenue - biz.weeklyOperatingCost;
      character.money += profit;
      logActivity(profit >= 0 ? "Bisnis ${biz.name} menghasilkan profit: ${formatCurrency(profit)}" : "Bisnis ${biz.name} mengalami kerugian: ${formatCurrency(profit.abs())}");
    }

    character.hunger = max(0, character.hunger - 7);
    character.mood = max(0, character.mood - 3);
    if (character.hunger < 20) {
      character.health = max(0, character.health - 10);
      character.mood = max(0, character.mood - 5);
      logActivity("Sangat lapar! Kesehatan & mood menurun drastis.");
    }
    if (character.health <= 0) {
      logActivity("Kesehatan Anda anjlok ke nol. Perjalanan Anda berakhir di sini.");
      isGameOver = true;
      notifyListeners();
      return;
    }
    if (character.week % 52 == 0) {
      character.age++;
      logActivity("Selamat ulang tahun ke-${character.age}!");
    }
    if (character.week % 8 == 0) _generateJobs();

    notifyListeners();
  }

  void logActivity(String message) {
    activityLog.insert(0, "[Usia ${character.age}, M${character.week}] $message");
    if (activityLog.length > 100) activityLog.removeLast();
    notifyListeners();
  }

  void applyForJob(Job job) {
    if (!character.skills.contains(job.requiredSkill)) {
      setSnackbar("Kualifikasi tidak terpenuhi: ${job.requiredSkill}");
      return;
    }

    if (job.jobType == JobType.permanent) {
      if (character.isStudying()) {
        setSnackbar("Tidak bisa mengambil pekerjaan tetap saat sedang menempuh pendidikan.");
        return;
      }
      character.currentJob = job;
      logActivity("Selamat! Anda sekarang bekerja sebagai ${job.title}.");
    } else { // Freelance
      character.activeFreelanceJobs.add(ActiveFreelanceJob(job: job, weeksLeft: job.durationInWeeks!));
      logActivity("Anda mengambil proyek freelance: ${job.title} (${job.durationInWeeks} minggu).");
    }
    notifyListeners();
  }

  void enrollInEducation(Education course) {
    if (character.isStudying()) {
      setSnackbar("Anda sudah terdaftar di suatu program pendidikan.");
      return;
    }
    if (!character.skills.contains(course.requiredSkill)) {
      setSnackbar("Prasyarat tidak terpenuhi: Anda memerlukan ${course.requiredSkill}.");
      return;
    }
    if (character.money < course.cost) {
      setSnackbar("Uang tidak cukup untuk mendaftar.");
      return;
    }

    character.money -= course.cost;
    character.currentEducation = course;
    character.educationWeeksLeft = course.durationInWeeks;
    character.currentJob = null;
    logActivity("Mendaftar di ${course.name}. Biaya: ${formatCurrency(course.cost)}");
    notifyListeners();
  }
  // ... sisa fungsi (buyFood, buyProperty, dll. tidak berubah)

  void buyFood(Food food) {
    if (character.money >= food.price) {
      character.money -= food.price;
      character.hunger = min(100, character.hunger + 40);
      character.health = min(100, character.health + food.healthBonus);
      character.mood = min(100, character.mood + food.moodBonus);
      logActivity("Membeli '${food.name}'.");
      notifyListeners();
    } else {
      setSnackbar("Gagal membeli ${food.name}. Uang tidak cukup.");
    }
  }

  void buyProperty(Property prop) {
    if (character.money >= prop.price) {
      character.money -= prop.price;
      character.properties.add(prop);
      logActivity("Membeli properti: ${prop.name}.");
      notifyListeners();
    } else {
      setSnackbar("Gagal membeli ${prop.name}. Uang tidak cukup.");
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
      logActivity("Membeli $units unit ${asset.name}.");
      notifyListeners();
    } else {
      setSnackbar("Gagal membeli ${asset.name}. Uang tidak cukup.");
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
        logActivity("Menjual $units unit ${asset.name}.");
        notifyListeners();
      } else {
        setSnackbar("Gagal menjual ${asset.name}. Unit tidak cukup.");
      }
    } else {
      setSnackbar("Anda tidak memiliki aset ini.");
    }
  }

  void startBusiness(Business biz) {
    if (character.money >= biz.capitalCost) {
      character.money -= biz.capitalCost;
      character.businesses.add(biz);
      logActivity("Selamat! Anda telah memulai bisnis: ${biz.name}.");
      notifyListeners();
    } else {
      setSnackbar("Gagal memulai ${biz.name}. Modal tidak cukup.");
    }
  }

  void depositSavings(double amount) {
    if (amount <= 0) return;
    if (character.money >= amount) {
      character.money -= amount;
      character.bankAccount.savings += amount;
      logActivity("Menabung ${formatCurrency(amount)} ke bank.");
      notifyListeners();
    } else {
      setSnackbar("Uang tunai tidak cukup.");
    }
  }

  void withdrawSavings(double amount) {
    if (amount <= 0) return;
    if (character.bankAccount.savings >= amount) {
      character.bankAccount.savings -= amount;
      character.money += amount;
      logActivity("Menarik ${formatCurrency(amount)} dari bank.");
      notifyListeners();
    } else {
      setSnackbar("Saldo tabungan tidak cukup.");
    }
  }

  void takeLoan(double amount) {
    if (amount <= 0) return;
    if (character.bankAccount.loan + amount <= maxLoanAmount) {
      character.bankAccount.loan += amount;
      character.money += amount;
      logActivity("Mengambil pinjaman ${formatCurrency(amount)}.");
      notifyListeners();
    } else {
      setSnackbar("Melebihi batas pinjaman maksimal Anda. Batas: ${formatCurrency(maxLoanAmount)}");
    }
  }

  void repayLoan(double amount) {
    if (amount <= 0) return;
    if (character.money >= amount) {
      double repayment = min(amount, character.bankAccount.loan);
      character.money -= repayment;
      character.bankAccount.loan -= repayment;
      logActivity("Membayar pinjaman ${formatCurrency(repayment)}.");
      notifyListeners();
    } else {
      setSnackbar("Uang tunai tidak cukup untuk membayar.");
    }
  }
}
