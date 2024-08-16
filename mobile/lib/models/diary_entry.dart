class DiaryEntry {
  final int? id;
  final DateTime date;
  String content;
  String summary = '';
  String sentiment = '';
  List<dynamic> futureEvents = <String>[];
  List<String> tags = <String>[];

  DiaryEntry({
    this.id,
    required this.date,
    required this.content,
    required this.summary,
    required this.sentiment,
    required this.futureEvents,
    required this.tags
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'content': content,
      'summary': summary,
      'sentiment': sentiment,
      'future_events': futureEvents.join('NEXT_EVENT'),
      'tags': tags.join(','),
    };
  }

  factory DiaryEntry.fromMap(Map<String, dynamic> map) {
    return DiaryEntry(
      date: DateTime.parse(map['date']),
      content: map['content'],
      summary: map['summary'],
      sentiment: map['sentiment'],
      futureEvents: map['future_events'].split('NEXT_EVENT'),
      tags: map['tags'].split(','),
    );
  }

  void addTag(String tag) {
    if (!tags.contains(tag)) {
      tags.add(tag);
    }
  }

  void removeTag(String tag) {
    tags.remove(tag);
  }
}
