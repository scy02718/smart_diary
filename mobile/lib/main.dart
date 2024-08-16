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

  // Function to get the start of the week (Monday)
  DateTime getStartOfWeek(DateTime date) {
    // DateTime.weekday is 1 for Monday and 7 for Sunday
    return date.subtract(Duration(days: date.weekday - 1));
  }

  // Function to generate a list of DiaryEntry for a week (Monday to Sunday)
  List<DiaryEntry> generateWeekEntries(DateTime today) {
    DateTime startOfWeek = getStartOfWeek(today);
    return List.generate(
      7,
      (index) => DiaryEntry(
        date: startOfWeek.add(Duration(days: index)),
      ),
    );
  }

  // Function to generate a list of weeks for the month view
  List<List<DiaryEntry>> generateMonthEntries(DateTime today) {
    List<List<DiaryEntry>> monthEntries = [];
    DateTime startOfMonth = DateTime(today.year, today.month, 1);
    DateTime endOfMonth = DateTime(today.year, today.month + 1, 0);
    
    DateTime currentWeekStart = getStartOfWeek(startOfMonth);

    while (currentWeekStart.isBefore(endOfMonth)) {
      List<DiaryEntry> weekEntries = generateWeekEntries(currentWeekStart);
      monthEntries.add(weekEntries);
      currentWeekStart = currentWeekStart.add(Duration(days: 7));
    }

    return monthEntries;
  }

  @override
  Widget build(BuildContext context) {
    // Mock data for demonstration purposes
    List<DiaryEntry> weekEntries = generateWeekEntries(DateTime.now());

    List<List<DiaryEntry>> monthEntries = generateMonthEntries(DateTime.now());

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
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  // Implement the refresh functionality here
                  print('Refresh button pressed');     
                },
              ),
            ],
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
