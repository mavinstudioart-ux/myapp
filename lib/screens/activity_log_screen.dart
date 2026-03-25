import 'package:flutter/material.dart';

class ActivityLogScreen extends StatelessWidget {
  final List<String> log;

  const ActivityLogScreen({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Log Aktivitas'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: log.isEmpty
          ? const Center(child: Text('Belum ada aktivitas.'))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: log.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  child: Text(
                    log[index],
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                );
              },
            ),
    );
  }
}
