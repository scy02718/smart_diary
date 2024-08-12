// screens/entry_detail_view.dart
import 'package:flutter/material.dart';
import '../models/diary_entry.dart';

class EntryDetailView extends StatefulWidget {
  final DiaryEntry entry;

  EntryDetailView({required this.entry});

  @override
  _EntryDetailViewState createState() => _EntryDetailViewState();
}

class _EntryDetailViewState extends State<EntryDetailView> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.entry.content);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _saveContent() {
    setState(() {
      widget.entry.content = _controller.text;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Entry'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveContent,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _controller,
          maxLines: null,
          decoration: InputDecoration(
            labelText: 'Your Diary Entry',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
