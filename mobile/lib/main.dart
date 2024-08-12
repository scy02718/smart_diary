// main.dart
import 'package:flutter/material.dart';
import 'screens/week_view.dart';
import 'screens/month_view.dart';
import 'models/diary_entry.dart';

void main() {
  runApp(DiaryApp());
}

class DiaryApp extends StatelessWidget {
  const DiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for demonstration purposes
    List<DiaryEntry> weekEntries = List.generate(
      7,
      (index) => DiaryEntry(date: DateTime.now().subtract(Duration(days: index))),
    );

    List<List<DiaryEntry>> monthEntries = List.generate(
      4,
      (index) => List.generate(
        7,
        (i) => DiaryEntry(date: DateTime.now().subtract(Duration(days: i + index * 7))),
      ),
    );

    return MaterialApp(
      title: 'Diary App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Diary'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Week View'),
                Tab(text: 'Month View'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              WeekView(weekEntries: weekEntries),
              MonthView(monthEntries: monthEntries),
            ],
          ),
        ),
      ),
    );
  }
}
