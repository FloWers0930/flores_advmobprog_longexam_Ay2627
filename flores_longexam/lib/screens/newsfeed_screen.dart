import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../services/post_service.dart';
import '../services/user_service.dart';
import '../widgets/post_card.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  final PostService _postService = PostService();
  final UserService _userService = UserService();

  List<Post> _posts = [];
  Map<int, User> _userMap = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    setState(() => _isLoading = true);

    try {
      final results = await Future.wait([
        _postService.getPosts(limit: 0),
        _userService.getAllUsers(),
      ]);

      final posts = results[0] as List<Post>;
      final users = results[1] as List<User>;

      final Map<int, User> map = {};
      for (var u in users) {
        map[u.id] = u;
      }

      if (mounted) {
        setState(() {
          _posts = posts;
          _userMap = map;
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
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: fbDarkPrimary),
      );
    }

    if (_posts.isEmpty) {
      return _buildFallbackFeed();
    }

    const int adIndex = 2; // Insert promo carousel after 2 posts

    return RefreshIndicator(
      color: fbDarkPrimary,
      onRefresh: _loadAllData,
      child: ListView.builder(
        itemCount: _posts.length + 1,
        itemBuilder: (context, index) {
          if (index == adIndex) {
            return _buildAdSection();
          }

          final postIndex = index > adIndex ? index - 1 : index;
          final post = _posts[postIndex];
          final author = _userMap[post.userId];

          final authorName = author != null && author.fullName.isNotEmpty
              ? author.fullName
              : (author?.username ?? 'User #${post.userId}');

          final avatarUrl = author?.image.isNotEmpty == true
              ? author!.image
              : 'https://dummyjson.com/icon/user_${post.userId}/128';

          return PostCard(
            postId: post.id,
            userName: authorName,
            postContent: post.body,
            numOfLikes: post.likes,
            date: 'Post #${post.id}',
            profileImageUrl: avatarUrl,
            imageUrl: '',
          );
        },
      ),
    );
  }

  Widget _buildAdSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Advertisement/Promotion',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        CarouselSlider(
          options: CarouselOptions(
            height: 308.h,
            enableInfiniteScroll: false,
            padEnds: false,
          ),
          items: _carouselItems(),
        ),
        SizedBox(height: 12.h),
      ],
    );
  }

  Widget _buildFallbackFeed() {
    final List<Map<String, dynamic>> fallbackPosts = [
      {
        'id': 1,
        'userName': 'Lawrenz Flores',
        'content': 'Paused here for the view.',
        'likes': 100,
        'date': 'October 11',
      },
      {
        'id': 2,
        'userName': 'Fionna',
        'content': 'There\'s always a rainbow after the storm.',
        'likes': 230,
        'date': 'December 2',
      },
      {
        'id': 3,
        'userName': 'Arf',
        'content': 'layo pa ng katapusan',
        'likes': 180,
        'date': 'December 5',
      },
    ];

    return ListView.builder(
      itemCount: fallbackPosts.length + 1,
      itemBuilder: (context, index) {
        if (index == 1) {
          return _buildAdSection();
        }

        final pIndex = index > 1 ? index - 1 : index;
        final p = fallbackPosts[pIndex];

        return PostCard(
          postId: p['id'] as int,
          userName: p['userName'] as String,
          postContent: p['content'] as String,
          numOfLikes: p['likes'] as int,
          date: p['date'] as String,
          profileImageUrl: '',
          imageUrl: '',
        );
      },
    );
  }

  List<Widget> _carouselItems() {
    final ads = [
      {
        'userName': 'Vince',
        'postContent': 'Hello',
        'date': 'October 11',
        'adsMarket': 'Ikaw na ito!',
        'imageUrl':
            'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1200&auto=format&fit=crop&q=60',
        'profileImageUrl':
            'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=200&auto=format&fit=crop&q=60',
      },
      {
        'userName': 'Travel Co.',
        'postContent': 'Book your next island escape.',
        'date': 'December 1',
        'adsMarket': 'Limited seats!',
        'imageUrl':
            'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=1200&auto=format&fit=crop&q=60',
        'profileImageUrl':
            'https://i.pinimg.com/1200x/12/86/94/128694b380379416b0668023d34d37a4.jpg',
      },
      {
        'userName': 'Coffee Hub',
        'postContent': 'Fresh beans, bold mornings.',
        'date': 'December 3',
        'adsMarket': 'Buy 1 get 1!',
        'imageUrl':
            'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=1200&auto=format&fit=crop&q=60',
        'profileImageUrl':
            'https://i.pinimg.com/736x/39/3b/b1/393bb1bb15940aea508dd07c5da23917.jpg',
      },
      {
        'userName': 'Fitness Lab',
        'postContent': 'Train smarter, move better.',
        'date': 'December 6',
        'adsMarket': 'Free trial week!',
        'imageUrl':
            'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=1200&auto=format&fit=crop&q=60',
        'profileImageUrl':
            'https://i.pinimg.com/736x/3f/c8/12/3fc81274aef4fce9c012ec53d8918d29.jpg',
      },
      {
        'userName': 'Gadget Mart',
        'postContent': 'Upgrade your everyday tech.',
        'date': 'December 10',
        'adsMarket': 'Holiday deals!',
        'imageUrl':
            'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=1200&auto=format&fit=crop&q=60',
        'profileImageUrl':
            'https://i.pinimg.com/736x/5e/75/2e/5e752e1f7715a5763ade09e445e30e27.jpg',
      },
      {
        'userName': 'Pet Care',
        'postContent': 'Happy pets, happy homes.',
        'date': 'December 12',
        'adsMarket': 'Vet checkup promo',
        'imageUrl':
            'https://images.unsplash.com/photo-1517849845537-4d257902454a?w=1200&auto=format&fit=crop&q=60',
        'profileImageUrl':
            'https://i.pinimg.com/736x/9a/9c/04/9a9c042f44d9c17a6828435584443727.jpg',
      },
    ];

    return ads
        .map(
          (ad) => _adsCard(
            userName: ad['userName'] as String,
            postContent: ad['postContent'] as String,
            date: ad['date'] as String,
            adsMarket: ad['adsMarket'] as String,
            imageUrl: ad['imageUrl'] as String,
            profileImageUrl: ad['profileImageUrl'] as String,
          ),
        )
        .toList();
  }

  Widget _adsCard({
    required String userName,
    required String postContent,
    required String date,
    required String adsMarket,
    required String imageUrl,
    required String profileImageUrl,
  }) {
    return PostCard(
      userName: userName,
      postContent: postContent,
      date: date,
      adsMarket: adsMarket,
      imageUrl: imageUrl,
      profileImageUrl: profileImageUrl,
    );
  }
}
