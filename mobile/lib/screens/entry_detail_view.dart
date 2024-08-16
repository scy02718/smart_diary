// lib/screens/entry_detail_view.dart
import 'package:flutter/material.dart';
import '../models/diary_entry.dart';
import '../data/repositories/data_repository.dart';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class EntryDetailView extends StatefulWidget {
  final DiaryEntry entry;

  const EntryDetailView({required this.entry, Key? key}) : super(key: key);

  @override
  _EntryDetailViewState createState() => _EntryDetailViewState();
}

class _EntryDetailViewState extends State<EntryDetailView> {
  final List<String> availableTags = ["work", "family", "vacation"];
  late GenerativeModel model;
  late ChatSession chat;

  final DiaryRepository _diaryRepo = DiaryRepository();

  @override
  void initState() {
    super.initState();
    _initModel();
  }

  Future<void> _initModel() async {
    try{
      await dotenv.load(fileName: ".env");
    } catch (e) {
      print("Error loading .env file: $e");
    }
    String apiKey = dotenv.env['API_KEY']!;

    model = GenerativeModel(model: "gemini-1.5-flash", apiKey: apiKey, generationConfig: GenerationConfig(responseMimeType: "application/json"));

    chat = model.startChat(history: [
      Content.text("""
      You are a diary summarizer. You will be given a diary entry, and you need to summarize it in a few sentences.
      Try to capture the essence of the diary entry in your summary, but try not to lose the details.
      Try to only summarize the things for the day, as future plans will be detected separately.
      Maximum length of summary should be 100 characters.

      Also, you should analyse and return the sentiment of the diary entry. The posible sentiments are:
      VERY POSITIVE, POSITIVE, NEUTRAL, NEGATIVE, VERY NEGATIVE.
      Also, you should detect all important future events and dates from the content of the diary entry.
      For example, if the diary entry says "I have a meeting with John tomorrow at 3pm", you should detect that the next day there is a meeting with John at 3pm.
      If there are no future events or dates, you should return ["No future events or dates detected"] in a list. Only detect Future events, not the one that already happened.
      You should return in this format:
      {
        "summary": "This is a generated summary for the day.",
        "sentiment": "positive"
        "future_events": ["event1", "event2"]
      }

      I will provide you with the diary entry now.      
      """),
      Content.model([TextPart('I understand. Please provide the diary entry.')]),
    ]);
  }

  Future<void> _generateSummary() async {
    if (widget.entry.content.isEmpty) {
      return;
    }

    try {
      var content = Content.text(widget.entry.content);
      var response = await chat.sendMessage(content);

      // Parse the JSON string response
      Map<String, dynamic> jsonResponse = jsonDecode(response.text!);

      // Extract summary and sentiment
      String summary = jsonResponse['summary'] ?? "Summary not available";
      String sentiment = jsonResponse['sentiment'] ?? "Sentiment not available";
      List<dynamic> futureEvents = jsonResponse['future_events'] ?? ["No future events or dates detected"];

      setState(() {
        widget.entry.summary = summary;
        widget.entry.sentiment = sentiment;
        widget.entry.futureEvents = futureEvents;
      });

    } catch (error) {
      print("Error generating summary: $error");
      setState(() {
        widget.entry.summary = "Error generating summary.";
      });
    } 

    await _diaryRepo.updateDiaryEntry(widget.entry);
  }  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add a text field to display the date of the diary entry
              Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.center,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue[800]
                ),
                child: Text(
                  _getFormattedDate(widget.entry.date),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
              ),
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
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      backgroundColor: Colors.grey,
                    ),
                    child: const Text('Return', style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: _generateSummary,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text('Save', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              if (widget.entry.summary.isNotEmpty) ...[
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.green,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Generated Summary:',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                      ),
                      const SizedBox(height: 10),
                      Text(widget.entry.summary, style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
              if (widget.entry.sentiment.isNotEmpty) ...[
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.blue,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sentiment:',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _getSentimentIcon(widget.entry.sentiment),
                          const SizedBox(width: 10),
                          Text(widget.entry.sentiment, style: const TextStyle(color: Colors.white)),
                        ],
                      )
                    ],
                  ),
                ),
              ],
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

  Icon _getSentimentIcon(String sentiment) {
    switch (sentiment) {
      case 'VERY POSITIVE':
        return const Icon(Icons.sentiment_very_satisfied, color: Colors.white);
      case 'POSITIVE':
        return const Icon(Icons.sentiment_satisfied, color: Colors.white);
      case 'NEUTRAL':
        return const Icon(Icons.sentiment_neutral, color: Colors.white);
      case 'NEGATIVE':
        return const Icon(Icons.sentiment_dissatisfied, color: Colors.white);
      case 'VERY NEGATIVE':
        return const Icon(Icons.sentiment_very_dissatisfied, color: Colors.white);
      default:
        return const Icon(Icons.sentiment_neutral, color: Colors.white);
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

