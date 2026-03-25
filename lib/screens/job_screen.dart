import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../game_state.dart';
import '../models/models.dart';
import '../utils/utils.dart';

class JobScreen extends StatelessWidget {
  const JobScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    final permanentJobs = gameState.jobBoard.where((job) => job.jobType == JobType.permanent).toList();
    final freelanceJobs = gameState.jobBoard.where((job) => job.jobType == JobType.freelance).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Peluang Karier'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pekerjaan Tetap'),
              Tab(text: 'Freelance'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildJobList(context, permanentJobs, gameState),
            _buildJobList(context, freelanceJobs, gameState),
          ],
        ),
      ),
    );
  }

  Widget _buildJobList(BuildContext context, List<Job> jobs, GameState gameState) {
    if (jobs.isEmpty) {
      return const Center(child: Text('Tidak ada pekerjaan tersedia saat ini.', style: TextStyle(color: Colors.white70)));
    }

    return ListView.builder(
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final job = jobs[index];
        bool canApply = gameState.character.skills.contains(job.requiredSkill);

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.white.withOpacity(0.15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            title: Text(job.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: _buildSubtitle(job),
            trailing: ElevatedButton(
              onPressed: canApply ? () => gameState.applyForJob(job) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: canApply ? Colors.green : Colors.grey.shade700,
              ),
              child: const Text('Lamar'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubtitle(Job job) {
    String skillInfo = 'Syarat: ${job.requiredSkill}';
    if (job.jobType == JobType.permanent) {
      String salaryInfo = 'Gaji: ${formatCurrency(job.salary!)}/minggu';
      return Text('$salaryInfo\n$skillInfo', style: TextStyle(color: Colors.white.withOpacity(0.8)));
    } else {
      String payoutInfo = 'Bayaran: ${formatCurrency(job.payout!)}';
      String durationInfo = 'Durasi: ${job.durationInWeeks} minggu';
      return Text('$payoutInfo • $durationInfo\n$skillInfo', style: TextStyle(color: Colors.white.withOpacity(0.8)));
    }
  }
}
