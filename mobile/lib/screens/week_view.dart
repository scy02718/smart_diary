// lib/screens/week_view.dart
import 'package:flutter/material.dart';
import '../models/diary_entry.dart';
import '../widgets/diary_entry_tile.dart';
import 'entry_detail_view.dart';

class WeekView extends StatelessWidget {
  final List<DiaryEntry> weekEntries;

  const WeekView({Key? key, required this.weekEntries}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: weekEntries.length,
        itemBuilder: (context, index) {
          final entry = weekEntries[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DiaryEntryTile(
                entry: entry,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EntryDetailView(entry: entry),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
