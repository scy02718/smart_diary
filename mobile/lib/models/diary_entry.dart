class DiaryEntry {
  final DateTime date;
  String content;
  String summary = '';
  List<String> tags = <String>[];

  DiaryEntry({
    required this.date,
    this.content = '',
    this.summary = '',
  });

  void addTag(String tag) {
    if (!tags.contains(tag)) {
      tags.add(tag);
    }
  }

  void removeTag(String tag) {
    tags.remove(tag);
  }
}
