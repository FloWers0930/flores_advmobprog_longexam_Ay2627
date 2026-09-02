import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flores_mobprog/widgets/custom_font.dart';

class CustomInformation extends StatelessWidget {
  const CustomInformation({
    super.key,
    required this.name,
    required this.post,
    required this.description,
    required this.date,
    required this.numOfLikes,
    required this.onTap,
    this.profileImageUrl = '',
  });

  final String name;
  final String post;
  final String description;
  final String date;
  final int numOfLikes;
  final VoidCallback onTap;
  final String profileImageUrl;

  bool _isNetworkImage(String url) {
    return url.startsWith('http://') || url.startsWith('https://');
  }

  Widget _buildAvatar() {
    if (profileImageUrl.isEmpty) {
      return CircleAvatar(
        radius: 18.sp,
        backgroundColor: Colors.grey.shade300,
        child: const Icon(Icons.person),
      );
    }

    if (_isNetworkImage(profileImageUrl)) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: profileImageUrl,
          width: 36.sp,
          height: 36.sp,
          fit: BoxFit.cover,
          placeholder: (_, _) =>
              CircleAvatar(radius: 18.sp, backgroundColor: Colors.grey[300]),
          errorWidget: (_, _, _) =>
              CircleAvatar(radius: 18.sp, backgroundColor: Colors.grey[300]),
        ),
      );
    }

    return CircleAvatar(
      radius: 18.sp,
      backgroundColor: Colors.grey.shade300,
      backgroundImage: AssetImage(profileImageUrl),
      onBackgroundImageError: (exception, stackTrace) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(15.sp),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAvatar(),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomFont(
                    text: name,
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  CustomFont(
                    text: 'Posted: $post',
                    fontSize: 13.sp,
                    color: Colors.black,
                  ),
                  CustomFont(
                    text: description,
                    fontSize: 12.sp,
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                  ),
                  SizedBox(height: 5.h),

                  CustomFont(text: date, fontSize: 11.sp, color: Colors.grey),
                ],
              ),
            ),
            const Icon(Icons.more_horiz),
          ],
        ),
      ),
    );
  }
}
