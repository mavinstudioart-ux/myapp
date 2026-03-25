import 'package:flutter/material.dart';

enum JobType { permanent, freelance }

class Character {
  String name = 'Player';
  String? profileImagePath;
  int age = 18;
  int week = 1;
  double money = 5000000;
  double health = 100;
  double mood = 100;
  double hunger = 100;
  List<String> skills = ['SMA'];
  Job? currentJob;
  List<ActiveFreelanceJob> activeFreelanceJobs = [];
  Education? currentEducation;
  int educationWeeksLeft = 0;
  List<Business> businesses = [];
  List<Investment> investments = [];
  List<Property> properties = [];
  BankAccount bankAccount = BankAccount();

  double get netWorth =>
      money +
      bankAccount.savings +
      investments.fold(0, (sum, item) => sum + (item.price * item.units)) +
      properties.fold(0, (sum, item) => sum + item.price) -
      bankAccount.loan;

  bool isStudying() => currentEducation != null && educationWeeksLeft > 0;

  void reset() {
    name = 'Player';
    profileImagePath = null;
    age = 18;
    week = 1;
    money = 5000000;
    health = 100;
    mood = 100;
    hunger = 100;
    skills = ['SMA'];
    currentJob = null;
    activeFreelanceJobs = [];
    currentEducation = null;
    educationWeeksLeft = 0;
    businesses = [];
    investments = [];
    properties = [];
    bankAccount = BankAccount();
  }
}

class Job {
  final String title;
  final String sector;
  final String requiredSkill;
  final JobType jobType;
  final double? salary; // Mingguan, untuk pekerjaan tetap
  final double? payout; // Total, untuk freelance
  final int? durationInWeeks; // Untuk freelance

  Job({
    required this.title,
    required this.sector,
    required this.requiredSkill,
    required this.jobType,
    this.salary,
    this.payout,
    this.durationInWeeks,
  });
}

class ActiveFreelanceJob {
  final Job job;
  int weeksLeft;

  ActiveFreelanceJob({required this.job, required this.weeksLeft});
}

class Education {
  String name;
  String description;
  int durationInWeeks;
  double cost;
  String skillAwarded;
  String requiredSkill;

  Education({
    required this.name,
    required this.description,
    required this.durationInWeeks,
    required this.cost,
    required this.skillAwarded,
    this.requiredSkill = "",
  });
}

class Business {
  String name;
  String sector;
  double capitalCost;
  double weeklyOperatingCost;
  double baseWeeklyRevenue;
  double volatility;

  Business({
    required this.name,
    required this.sector,
    required this.capitalCost,
    required this.weeklyOperatingCost,
    required this.baseWeeklyRevenue,
    required this.volatility,
  });

  double calculateWeeklyRevenue() {
    // Implementasi logika pendapatan bisnis
    return baseWeeklyRevenue;
  }
}

class Investment {
  String name;
  double price;
  double units;

  Investment({required this.name, required this.price, this.units = 0});
}

class Food {
  String name;
  double price;
  int healthBonus;
  int moodBonus;

  Food(
      {required this.name,
      required this.price,
      this.healthBonus = 0,
      this.moodBonus = 0});
}

class Property {
  String name;
  double price;
  double weeklyIncome;

  Property({required this.name, required this.price, required this.weeklyIncome});
}

class BankAccount {
  double savings = 0;
  double loan = 0;
  double savingsInterestRate = 0.005; // 0.5% per minggu
  double loanInterestRate = 0.02; // 2% per minggu
}
