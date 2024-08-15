// lib/screens/entry_detail_view.dart
import 'package:flutter/material.dart';
import '../models/diary_entry.dart';

class EntryDetailView extends StatefulWidget {
  final DiaryEntry entry;

  const EntryDetailView({required this.entry, Key? key}) : super(key: key);

  @override
  _EntryDetailViewState createState() => _EntryDetailViewState();
}

class _EntryDetailViewState extends State<EntryDetailView> {
  final List<String> availableTags = ["work", "family", "vacation"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diary Entry'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: TextEditingController(text: widget.entry.content),
              onChanged: (value) {
                widget.entry.content = value;
              },
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Write your entry...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Tags:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: availableTags.map((tag) {
                final isSelected = widget.entry.tags.contains(tag);
                return ChoiceChip(
                  label: Text(tag),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        widget.entry.addTag(tag);
                      } else {
                        widget.entry.removeTag(tag);
                      }
                    });
                  },
                  selectedColor: _getTagColor(tag),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                );
              }).toList(),
            ),
          ],
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
}
