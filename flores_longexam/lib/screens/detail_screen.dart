import 'package:cached_network_image/cached_network_image.dart';
import 'package:flores_mobprog/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/comment.dart';
import '../services/comment_service.dart';
import '../services/user_service.dart';
import '../widgets/custom_font.dart';

class DetailScreen extends StatefulWidget {
  final int postId;
  final String userName;
  final String postContent;
  final String date;
  final int numOfLikes;
  final String image;
  final String profileImage;

  const DetailScreen({
    super.key,
    this.postId = 1,
    required this.userName,
    required this.postContent,
    required this.date,
    this.numOfLikes = 0,
    this.image = '',
    this.profileImage = '',
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late int likes;
  bool isLiked = false;

  final CommentService _commentService = CommentService();
  final UserService _userService = UserService();
  final TextEditingController _commentController = TextEditingController();

  List<Comment> _comments = [];
  bool _isLoadingComments = true;
  bool _isSubmittingComment = false;
  int _currentUserId = 1;
  String _currentUsername = 'User';

  @override
  void initState() {
    super.initState();
    likes = widget.numOfLikes;
    _loadUserAndComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _loadUserAndComments() async {
    final user = await _userService.getSavedUser();
    if (user != null) {
      _currentUserId = user.id;
      _currentUsername = user.fullName.isNotEmpty
          ? user.fullName
          : user.username;
    }

    try {
      final fetchedComments = await _commentService.getCommentsByPostId(
        widget.postId,
      );
      if (mounted) {
        setState(() {
          _comments = fetchedComments;
          _isLoadingComments = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoadingComments = false;
        });
      }
    }
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
      likes += isLiked ? 1 : -1;
      if (likes < 0) likes = 0;
    });
  }

  Future<void> _submitComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isSubmittingComment = true);

    try {
      final newComment = await _commentService.addComment(
        postId: widget.postId,
        userId: _currentUserId,
        body: text,
      );

      if (!mounted) return;
      setState(() {
        _comments.insert(0, newComment);
        _commentController.clear();
        _isSubmittingComment = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Comment posted!'),
          duration: Duration(seconds: 1),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      // Optimistic fallback for demo
      final localComment = Comment(
        id: DateTime.now().millisecondsSinceEpoch,
        body: text,
        postId: widget.postId,
        likes: 0,
        userId: _currentUserId,
        username: _currentUsername,
        userFullName: _currentUsername,
      );
      setState(() {
        _comments.insert(0, localComment);
        _commentController.clear();
        _isSubmittingComment = false;
      });
    }
  }

  bool _isNetworkImage(String url) {
    return url.startsWith('http://') || url.startsWith('https://');
  }

  Widget _buildHeaderImage() {
    if (widget.image.isEmpty) {
      return const SizedBox();
    }

    if (_isNetworkImage(widget.image)) {
      return CachedNetworkImage(
        imageUrl: widget.image,
        width: double.infinity,
        height: 260.h,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            CircularProgressIndicator(
              color: fbDarkPrimary,
              value: downloadProgress.progress,
            ),
        errorWidget: (context, url, error) => Container(
          height: 260.h,
          color: Colors.grey.shade300,
          child: const Icon(Icons.error),
        ),
      );
    }

    return Image.asset(
      widget.image,
      width: double.infinity,
      height: 260.h,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => const SizedBox(),
    );
  }

  Widget _buildProfileAvatar() {
    if (widget.profileImage.isEmpty) {
      return CircleAvatar(
        radius: 22.sp,
        backgroundColor: Colors.grey.shade300,
        child: const Icon(Icons.person),
      );
    }

    if (_isNetworkImage(widget.profileImage)) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: widget.profileImage,
          width: 44.sp,
          height: 44.sp,
          fit: BoxFit.cover,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              CircularProgressIndicator(
                color: fbDarkPrimary,
                value: downloadProgress.progress,
              ),
          errorWidget: (context, url, error) => CircleAvatar(
            radius: 22.sp,
            backgroundColor: Colors.grey.shade300,
            child: const Icon(Icons.person),
          ),
        ),
      );
    }

    return CircleAvatar(
      radius: 22.sp,
      backgroundImage: AssetImage(widget.profileImage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: CustomFont(
          text: widget.userName,
          fontSize: 18.sp,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderImage(),
                  SizedBox(height: 12.h),

                  // User Info Header
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: [
                        _buildProfileAvatar(),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomFont(
                                text: widget.userName,
                                fontSize: 16.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              Row(
                                children: [
                                  CustomFont(
                                    text: widget.date,
                                    fontSize: 12.sp,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 4.w),
                                  Icon(
                                    Icons.public,
                                    size: 14.sp,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.more_horiz),
                      ],
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // Post Content
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CustomFont(
                        text: widget.postContent,
                        fontSize: 15.sp,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),
                  const Divider(height: 1),

                  // Interactive Action Buttons
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 4.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: toggleLike,
                          icon: Icon(
                            isLiked
                                ? Icons.thumb_up
                                : Icons.thumb_up_alt_outlined,
                            color: isLiked ? fbPrimary : Colors.grey,
                          ),
                          label: CustomFont(
                            text: likes == 0 ? 'Like' : likes.toString(),
                            fontSize: 13.sp,
                            color: isLiked ? fbPrimary : Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.mode_comment_outlined,
                            color: Colors.grey,
                          ),
                          label: CustomFont(
                            text: _comments.isNotEmpty
                                ? '${_comments.length} Comments'
                                : 'Comment',
                            fontSize: 13.sp,
                            color: Colors.grey,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.redo, color: Colors.grey),
                          label: CustomFont(
                            text: 'Share',
                            fontSize: 13.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1),
                  SizedBox(height: 12.h),

                  // Comments Section Header
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: [
                        CustomFont(
                          text: 'Comments (${_comments.length})',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        if (_isLoadingComments) ...[
                          SizedBox(width: 8.w),
                          SizedBox(
                            width: 14.w,
                            height: 14.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  SizedBox(height: 8.h),

                  // Render Comments List
                  if (_isLoadingComments)
                    const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (_comments.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 24.h,
                      ),
                      child: Center(
                        child: Text(
                          'No comments yet. Be the first to comment!',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _comments.length,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemBuilder: (context, index) {
                        final c = _comments[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 6.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 16.r,
                                backgroundColor: fbDarkPrimary.withValues(
                                  alpha: 0.1,
                                ),
                                child: Text(
                                  c.userFullName.isNotEmpty
                                      ? c.userFullName[0].toUpperCase()
                                      : 'U',
                                  style: TextStyle(
                                    color: fbDarkPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 8.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        c.userFullName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.sp,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 3.h),
                                      Text(
                                        c.body,
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),

          // Add Comment Input Bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  offset: const Offset(0, -2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: 'Write a comment...',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 13.sp,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 10.h,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  IconButton(
                    onPressed: _isSubmittingComment ? null : _submitComment,
                    icon: _isSubmittingComment
                        ? SizedBox(
                            width: 18.w,
                            height: 18.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.send, color: fbLightPrimary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
