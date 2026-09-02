import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/custom_inkwell_button.dart';
import '../screens/detail_screen.dart';

import '../constants.dart';
import 'custom_font.dart';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PostCard extends StatefulWidget {
  final String userName;
  final String postContent;
  final String date;
  int numOfLikes;
  final String imageUrl;
  final String profileImageUrl;
  final int postId;
  final String adsMarket;

  PostCard({
    super.key,
    this.postId = 1,
    required this.userName,
    required this.postContent,
    this.numOfLikes = 0,
    required this.date,
    this.imageUrl = '',
    this.profileImageUrl = '',
    this.adsMarket = '',
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  void _openDetailScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(
          postId: widget.postId,
          userName: widget.userName,
          postContent: widget.postContent,
          date: widget.date,
          numOfLikes: widget.numOfLikes,
          image: widget.imageUrl,
          profileImage: widget.profileImageUrl,
        ),
      ),
    );
  }

  bool _isNetworkImage(String url) {
    return url.startsWith('http://') || url.startsWith('https://');
  }

  Widget _buildAvatar() {
    if (widget.profileImageUrl.isEmpty) {
      return const Icon(Icons.person);
    }

    if (_isNetworkImage(widget.profileImageUrl)) {
      return ClipOval(
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          width: 30,
          height: 30,
          imageUrl: widget.profileImageUrl,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              CircularProgressIndicator(
                color: fbDarkPrimary,
                value: downloadProgress.progress,
              ),
          errorWidget: (context, url, error) => Icon(Icons.error, size: 100.sp),
        ),
      );
    }

    return ClipOval(
      child: Image.asset(
        widget.profileImageUrl,
        width: 30,
        height: 30,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: 30,
          height: 30,
          color: Colors.grey.shade200,
          child: const Icon(Icons.person, size: 18, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildPostImage() {
    if (widget.imageUrl.isEmpty) {
      return SizedBox(height: ScreenUtil().setHeight(0.1));
    }

    final double? fixedHeight = widget.adsMarket.isNotEmpty ? 150.h : null;

    if (_isNetworkImage(widget.imageUrl)) {
      return Align(
        alignment: Alignment.center,
        child: CachedNetworkImage(
          imageUrl: widget.imageUrl,
          width: double.infinity,
          height: fixedHeight,
          fit: BoxFit.cover,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              CircularProgressIndicator(
                color: fbDarkPrimary,
                value: downloadProgress.progress,
              ),
          errorWidget: (context, url, error) => const SizedBox(),
        ),
      );
    }

    return Align(
      alignment: Alignment.center,
      child: Image.asset(
        widget.imageUrl,
        width: double.infinity,
        height: fixedHeight,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const SizedBox(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openDetailScreen,
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.all(ScreenUtil().setSp(10)),
        child: Padding(
          padding: EdgeInsets.all(ScreenUtil().setSp(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildAvatar(),
                  SizedBox(width: ScreenUtil().setWidth(10)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomFont(
                        text: widget.userName,
                        fontSize: ScreenUtil().setSp(15),
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomFont(
                            text: widget.date,
                            fontSize: ScreenUtil().setSp(12),
                            color: Colors.grey,
                          ),
                          SizedBox(width: ScreenUtil().setWidth(3)),
                          Icon(
                            Icons.public,
                            color: Colors.grey,
                            size: ScreenUtil().setSp(15),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.more_horiz),
                ],
              ),
              SizedBox(height: ScreenUtil().setHeight(5)),
              CustomFont(
                text: widget.postContent,
                fontSize: ScreenUtil().setSp(12),
                color: Colors.black,
              ),
              SizedBox(height: ScreenUtil().setHeight(5)),
              _buildPostImage(),
              SizedBox(height: ScreenUtil().setHeight(5)),
              (widget.adsMarket != '')
                  ? const SizedBox()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              widget.numOfLikes++;
                            });
                          },
                          icon: const Icon(
                            Icons.thumb_up,
                            color: fbDarkPrimary,
                          ),
                          label: CustomFont(
                            text: (widget.numOfLikes == 0)
                                ? 'Like'
                                : widget.numOfLikes.toString(),
                            fontSize: ScreenUtil().setSp(12),
                            color: fbDarkPrimary,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _openDetailScreen,
                          icon: const Icon(Icons.comment, color: fbDarkPrimary),
                          label: CustomFont(
                            text: 'Comment',
                            fontSize: ScreenUtil().setSp(12),
                            color: fbDarkPrimary,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.redo, color: fbDarkPrimary),
                          label: CustomFont(
                            text: 'Share',
                            fontSize: ScreenUtil().setSp(12),
                            color: fbDarkPrimary,
                          ),
                        ),
                      ],
                    ),

              (widget.adsMarket != '')
                  ? const SizedBox()
                  : Row(
                      children: [
                        const Icon(Icons.person),
                        SizedBox(width: ScreenUtil().setWidth(10)),
                        Container(
                          padding: EdgeInsets.fromLTRB(
                            ScreenUtil().setSp(10),
                            0,
                            0,
                            0,
                          ),
                          alignment: Alignment.centerLeft,
                          height: ScreenUtil().setHeight(25),
                          width: ScreenUtil().setWidth(330),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.all(
                              Radius.circular(ScreenUtil().setSp(10)),
                            ),
                          ),
                          child: CustomFont(
                            text: 'Write a comment...',
                            fontSize: ScreenUtil().setSp(11),
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

              (widget.adsMarket != '')
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 4.h,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomFont(
                                  text: 'MORE DETAILS',
                                  fontSize: 16.sp,
                                  color: Colors.black,
                                ),
                                SizedBox(height: 2.h),
                                CustomFont(
                                  text: widget.adsMarket,
                                  fontSize: 16.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8.w),
                          CustomInkwellButton(
                            width: 90.w,
                            height: 40.h,
                            icon: Icon(
                              Icons.arrow_right_alt,
                              color: fbLightPrimary,
                            ),
                            onTap: _openDetailScreen,
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),

              SizedBox(
                height: widget.adsMarket != ''
                    ? ScreenUtil().setHeight(4)
                    : ScreenUtil().setHeight(10),
              ),

              (widget.adsMarket != '')
                  ? const SizedBox()
                  : GestureDetector(
                      onTap: _openDetailScreen,
                      child: CustomFont(
                        text: 'View comments',
                        fontSize: ScreenUtil().setSp(12),
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
