import 'package:flutter/material.dart';
import 'package:newsee/feature/leadInbox/presentation/bloc/lead_bloc.dart';

class PerformanceView extends StatelessWidget {
  const PerformanceView({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = LeadPerformanceStats();

    return Container(
      padding: const EdgeInsets.all(16),
      height: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Performance Comparison",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard(
                "Before Cache",
                stats.beforeCacheTime?.inMilliseconds.toString() ?? "",
                stats.beforeCacheCount ?? 0,
              ),
              _buildStatCard(
                "After Cache",
                stats.afterCacheTime?.inMilliseconds.toString() ?? "",
                stats.afterCacheCount ?? 0,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String time, int count) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Load: ${time}ms"),
            Text("Records: $count"),
          ],
        ),
      ),
    );
  }
}
