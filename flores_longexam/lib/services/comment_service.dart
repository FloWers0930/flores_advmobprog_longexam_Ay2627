import 'dart:convert';
import 'package:http/http.dart';

import '../constants.dart';
import '../models/comment.dart';

class CommentService {
  /// Fetch all comments for a specific post from DummyJSON
  Future<List<Comment>> getCommentsByPostId(int postId) async {
    final uri = Uri.parse('$host/comments/post/$postId');
    final response = await get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List commentsJson = data['comments'] ?? [];
      return commentsJson.map((c) => Comment.fromJson(c)).toList();
    } else {
      throw Exception('Failed to load comments: ${response.statusCode}');
    }
  }

  /// Add a new comment to a post via DummyJSON
  Future<Comment> addComment({
    required int postId,
    required int userId,
    required String body,
  }) async {
    final uri = Uri.parse('$host/comments/add');
    final response = await post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'body': body.trim(),
        'postId': postId,
        'userId': userId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Comment.fromJson(data);
    } else {
      throw Exception('Failed to add comment: ${response.statusCode}');
    }
  }

  /// Fetch recent comments across posts from DummyJSON
  Future<List<Comment>> getAllComments({int limit = 30}) async {
    try {
      final uri = Uri.parse('$host/comments?limit=$limit');
      final response = await get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List commentsJson = data['comments'] ?? [];
        return commentsJson
            .map((c) => Comment.fromJson(c as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}
    return [];
  }
}
