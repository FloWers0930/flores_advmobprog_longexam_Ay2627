import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants.dart';
import '../models/comment.dart';
import '../services/comment_service.dart';
import '../widgets/custom_info.dart';
import 'detail_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final CommentService _commentService = CommentService();
  List<Comment> _comments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);

    try {
      final comments = await _commentService.getAllComments(limit: 30);
      if (mounted) {
        setState(() {
          _comments = comments;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: fbDarkPrimary),
              )
            : RefreshIndicator(
                color: fbDarkPrimary,
                onRefresh: _loadNotifications,
                child: _comments.isEmpty
                    ? const Center(
                        child: Text(
                          'No notifications at this time.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        itemCount: _comments.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final c = _comments[index];

                          return CustomInformation(
                            name: c.userFullName.isNotEmpty
                                ? c.userFullName
                                : c.username,
                            post: c.body,
                            description: 'Commented on post #${c.postId}',
                            date: 'Activity',
                            numOfLikes: c.likes,
                            profileImageUrl:
                                'https://dummyjson.com/icon/user_${c.userId}/128',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailScreen(
                                    postId: c.postId,
                                    userName: c.userFullName.isNotEmpty
                                        ? c.userFullName
                                        : c.username,
                                    postContent: c.body,
                                    date: 'Post #${c.postId}',
                                    numOfLikes: c.likes,
                                    profileImage:
                                        'https://dummyjson.com/icon/user_${c.userId}/128',
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
      ),
    );
  }
}
