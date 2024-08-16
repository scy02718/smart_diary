// lib/widgets/diary_entry_tile.dart
import 'package:flutter/material.dart';
import '../models/diary_entry.dart';

class DiaryEntryTile extends StatelessWidget {
  final DiaryEntry entry;
  final VoidCallback onTap;

  const DiaryEntryTile({
    required this.entry,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(  
                children: [
                  if (entry.sentiment.isNotEmpty) Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Text(
                      entry.sentiment,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    )
                  ),
                  const SizedBox(width: 5),
                  Wrap(
                    spacing: 5,
                    children: entry.tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getTagColor(tag),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                _getFormattedDate(entry.date),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 5),
              Text(entry.summary),
              const SizedBox(height: 10),
              if (entry.futureEvents.isNotEmpty) Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Reminder:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Wrap(
                    spacing: 5,
                    children: entry.futureEvents.map((event) {
                      return Container(
                        margin: const EdgeInsets.only(top: 2, bottom: 2),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Text(
                          event,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTagColor(String tag) {
    switch (tag) {
      case 'work':
        return Colors.blue;
      case 'family':
        return Colors.green;
      case 'vacation':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getFormattedDate(DateTime date) {
    const monthToString = {
      1: 'Jan',
      2: 'Feb',
      3: 'Mar',
      4: 'Apr',
      5: 'May',
      6: 'Jun',
      7: 'Jul',
      8: 'Aug',
      9: 'Sep',
      10: 'Oct',
      11: 'Nov',
      12: 'Dec',
    };

    const dateToday = {
        1: 'Monday',
        2: 'Tuesday',
        3: 'Wednesday',
        4: 'Thursday',
        5: 'Friday',
        6: 'Saturday',
        7: 'Sunday',
      };

    return '${dateToday[date.weekday]} ${date.day} ${monthToString[date.month]}, ${date.year}';
  }
}
