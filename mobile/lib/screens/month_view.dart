// screens/month_view.dart
import 'package:flutter/material.dart';
import '../models/diary_entry.dart';
import 'week_view.dart';

class MonthView extends StatelessWidget {
  final List<List<DiaryEntry>> monthEntries;

  MonthView({required this.monthEntries});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Month View')),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
        ),
        itemCount: monthEntries.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WeekView(weekEntries: monthEntries[index]),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Text('Week ${index + 1} Summary (To be implemented)'),
              ),
            ),
          );
        },
      ),
    );
  }
}
