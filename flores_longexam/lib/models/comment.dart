class Comment {
  final int id;
  final String body;
  final int postId;
  final int likes;
  final int userId;
  final String username;
  final String userFullName;

  Comment({
    required this.id,
    required this.body,
    required this.postId,
    this.likes = 0,
    this.userId = 0,
    this.username = 'User',
    this.userFullName = 'User',
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    int uId = 0;
    String uName = 'User';
    String fName = 'User';

    if (json['user'] is Map<String, dynamic>) {
      final userObj = json['user'] as Map<String, dynamic>;
      uId = userObj['id'] as int? ?? 0;
      uName = userObj['username'] as String? ?? 'User';
      fName =
          userObj['fullName'] as String? ?? userObj['name'] as String? ?? uName;
    } else {
      uId = json['userId'] as int? ?? 0;
      uName = json['username'] as String? ?? json['name'] as String? ?? 'User';
      fName = json['fullName'] as String? ?? uName;
    }

    return Comment(
      id: json['id'] as int? ?? 0,
      body: json['body'] as String? ?? '',
      postId: json['postId'] as int? ?? 0,
      likes: json['likes'] as int? ?? 0,
      userId: uId,
      username: uName,
      userFullName: fName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'body': body,
      'postId': postId,
      'likes': likes,
      'userId': userId,
      'user': {'id': userId, 'username': username, 'fullName': userFullName},
    };
  }
}
