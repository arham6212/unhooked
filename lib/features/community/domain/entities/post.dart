class Post {
  final String id;
  final String userId;
  final String? title;
  final String body;
  final int likesCount;
  final int commentsCount;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.userId,
    this.title,
    required this.body,
    required this.likesCount,
    required this.commentsCount,
    required this.createdAt,
  });
}
