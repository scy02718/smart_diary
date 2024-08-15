// lib/screens/entry_detail_view.dart
import 'package:flutter/material.dart';
import '../models/diary_entry.dart';
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
  
  @override
  void initState() {
    super.initState();
    _initModel();
  }

  Future<void> _initModel() async {
    await dotenv.load(fileName: ".env");
    String apiKey = dotenv.env['API_KEY']!;

    model = GenerativeModel(model: "gemini-1.5-flash", apiKey: apiKey, generationConfig: GenerationConfig(responseMimeType: "application/json"));

    chat = model.startChat(history: [
      Content.text("""
      You are a diary summarizer. You will be given a diary entry, and you need to summarize it in a few sentences.
      Try to capture the essence of the diary entry in your summary, but try not to lose the details.
      Maximum length of summary should be 100 characters.

      Also, you should also analyse and return the sentiment of the diary entry. The posible sentiments are:
      VERY POSITIVE, POSITIVE, NEUTRAL, NEGATIVE, VERY NEGATIVE.
      You should return in this format:
      {
        "summary": "This is a generated summary for the day.",
        "sentiment": "positive"
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

      setState(() {
        widget.entry.summary = summary;
        widget.entry.sentiment = sentiment;
      });

    } catch (error) {
      print("Error generating summary: $error");
      setState(() {
        widget.entry.summary = "Error generating summary.";
      });
    } 
  }

  
  //I woke up and prepared quickly to pick up my girlfriend and go to library to do some school assignment. I successfully did it on time, and picked her up
  //We went to get food, where we grabbed poke. We also grabbed some coffee, and the manager at the coffee place was someone that we knew, she gave us free croissants.
  //With a lot of food, we went to the library and ate all of them. It was good, and we did a lot of work.
  

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
                  "Date: ${widget.entry.date.day}/${widget.entry.date.month}/${widget.entry.date.year}",
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
}

