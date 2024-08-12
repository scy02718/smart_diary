// screens/week_view.dart
import 'package:flutter/material.dart';
import '../models/diary_entry.dart';
import '../widgets/diary_entry_tile.dart';
import 'entry_detail_view.dart';

class WeekView extends StatelessWidget {
  final List<DiaryEntry> weekEntries;

  const WeekView({required this.weekEntries});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Week View')),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: weekEntries.length,
        itemBuilder: (context, index) {
          return DiaryEntryTile(
            entry: weekEntries[index],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EntryDetailView(entry: weekEntries[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
