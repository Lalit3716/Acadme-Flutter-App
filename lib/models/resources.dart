class Resource {
  final String id;
  final String title;
  final String description;
  final String? thumbnail;
  final String link;
  final String authorName;
  final int upvotes;
  final int downvotes;
  final List<String> tags;
  final String createdAt;
  final String type;

  Resource({
    required this.id,
    required this.title,
    required this.description,
    required this.tags,
    this.thumbnail,
    required this.createdAt,
    required this.type,
    required this.link,
    required this.authorName,
    required this.upvotes,
    required this.downvotes,
  });

  static Resource fromJSON(Map<String, dynamic> json) {
    return Resource(
      id: json['_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      thumbnail: json['thumbnail'] as String?,
      link: json['link'] as String,
      authorName: json['authorName'] as String,
      upvotes: json['upvotes'] as int,
      downvotes: json['downvotes'] as int,
      tags: (json['tags'] as List<dynamic>).cast<String>(),
      createdAt: DateTime.parse(json['createdAt'] as String).toIso8601String(),
      type: json['type'] as String,
    );
  }
}
