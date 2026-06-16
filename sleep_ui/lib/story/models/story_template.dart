class StoryTemplate {
  final String storyid;
  final String title;
  final String description;
  final String storyText;
  final String language;
  final String? thumbnailPath;
  final DateTime? createdat;

  StoryTemplate({
    required this.storyid,
    required this.title,
    required this.description,
    required this.storyText,
    required this.language,
    this.thumbnailPath,
    this.createdat,
  });

  factory StoryTemplate.fromMap(Map<String, dynamic> map) {
    return StoryTemplate(
      storyid: map['storyid']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      storyText: map['story_text']?.toString() ?? '',
      language: map['language']?.toString() ?? 'en',
      thumbnailPath: map['thumbnail_path']?.toString(),
      createdat: map['createdat'] != null 
          ? DateTime.tryParse(map['createdat'].toString()) 
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'storyid': storyid,
      'title': title,
      'description': description,
      'story_text': storyText,
      'language': language,
      'thumbnail_path': thumbnailPath,
      'createdat': createdat?.toIso8601String(),
    };
  }

  /// Calculates reading duration in minutes based on 150 words per minute.
  int get durationMinutes {
    if (storyText.isEmpty) return 0;
    // Split on any whitespace to count words
    final wordCount = storyText.trim().split(RegExp(r'\s+')).length;
    final minutes = (wordCount / 150).ceil();
    return minutes > 0 ? minutes : 1;
  }
}
