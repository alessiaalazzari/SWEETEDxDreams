class Talk {
  final String title;
  final String details;
  final String mainSpeaker;
  final String url;

  Talk({
    required this.title,
    required this.details,
    required this.mainSpeaker,
    required this.url,
  });

  factory Talk.fromJSON(Map<String, dynamic> json) {
    return Talk(
      title: json['title'] ?? '',
      details: json['description'] ?? '',
      mainSpeaker: json['speakers'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

class Talk2 {
  final List<String> watchNextId;
  final List<String> watchNextTitle;

  Talk2({
    required this.watchNextId,
    required this.watchNextTitle,
  });

  factory Talk2.fromJSON(Map<String, dynamic> json) {
    return Talk2(
      watchNextId: List<String>.from(json['WatchNext_id'] ?? []),
      watchNextTitle: List<String>.from(json['WatchNext_title'] ?? []),
    );
  }
}
