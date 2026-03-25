import 'dart:math';

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
  String? profileImagePath;

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
    profileImagePath = null;
  }
}

class BankAccount {
  double savings = 0;
  double loan = 0;
  final double savingsInterestRate = 0.005; // 0.5% per week
  final double loanInterestRate = 0.015; // 1.5% per week
  void reset() {
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
  final double volatility;

  Business({
    required this.name,
    required this.sector,
    required this.capitalCost,
    required this.weeklyOperatingCost,
    required this.baseWeeklyRevenue,
    required this.volatility,
  });

  double calculateWeeklyRevenue() {
    final randomFactor = (Random().nextDouble() * 2 - 1) * volatility;
    return baseWeeklyRevenue * (1 + randomFactor);
  }
}

class Job {
  final String title;
  final String sector;
  final double salary;
  final String requiredSkill;
  Job({required this.title, required this.sector, required this.salary, required this.requiredSkill});
}

class Education {
  final String name;
  final String description;
  final int durationInWeeks;
  final double cost;
  final String skillAwarded;
  final String requiredSkill;
  Education({required this.name, required this.description, required this.durationInWeeks, required this.cost, required this.skillAwarded, this.requiredSkill = "SMA"});
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
