import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../constants.dart';
import '../models/post.dart';
import '../services/post_service.dart';
import '../services/user_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/post_card.dart';
import '../models/user.dart';

class ProfileScreen extends StatefulWidget {
  final String username;
  final int? userId;

  const ProfileScreen({super.key, required this.username, this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();
  User? _currentUser;
  int _userId = 5; // Default fallback to user 5 on DummyJSON

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    if (widget.userId != null) {
      setState(() => _userId = widget.userId!);
      return;
    }

    final user = await _userService.getSavedUser();
    if (user != null && mounted) {
      setState(() {
        _currentUser = user;
        _userId = user.id > 0 ? user.id : 5;
      });
    }
  }

  String _displayName(String username) {
    if (_currentUser != null && _currentUser!.fullName.isNotEmpty) {
      return _currentUser!.fullName;
    }
    if (username.contains('@')) return username.split('@').first;
    return username;
  }

  @override
  Widget build(BuildContext context) {
    final displayName = _displayName(widget.username);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: _ProfileHeader(
                username: displayName,
                avatarUrl: _currentUser?.image ?? '',
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarDelegate(
                TabBar(
                  indicatorColor: fbDarkPrimary,
                  labelColor: Colors.black,
                  tabs: const [
                    Tab(text: "Posts"),
                    Tab(text: "About"),
                    Tab(text: "Photos"),
                  ],
                ),
              ),
            ),
          ],
          body: TabBarView(
            children: [
              _PostsTab(displayName: displayName, userId: _userId),
              const _AboutTab(),
              const _PhotosTab(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String username;
  final String avatarUrl;

  const _ProfileHeader({required this.username, this.avatarUrl = ''});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            CachedNetworkImage(
              imageUrl:
                  'https://i.pinimg.com/736x/50/5e/8e/505e8eb54f13df32462afc23242e1bf7.jpg',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (_, _) =>
                  Container(height: 200, color: Colors.grey[300]),
            ),

            Positioned(
              bottom: -50,
              left: 20,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: avatarUrl.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: avatarUrl,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => const Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.grey,
                              ),
                            )
                          : CachedNetworkImage(
                              imageUrl:
                                  'https://i.pinimg.com/1200x/4f/c7/4b/4fc74b0567a6de8369479c14746c2216.jpg',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),

                  const Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.camera_alt,
                        size: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 55.h),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10.h),

              const Row(
                children: [
                  _Stat(value: "999", label: "followers"),
                  _Dot(),
                  _Stat(value: "3", label: "following"),
                ],
              ),

              SizedBox(height: 10.h),

              Row(
                children: [
                  CustomButton(
                    buttonName: "Follow",
                    buttonType: CustomButtonType.filled,
                    onPressed: () {},
                  ),
                  SizedBox(width: 10.w),
                  CustomButton(
                    buttonName: "Message",
                    buttonType: CustomButtonType.outlined,
                    onPressed: () {},
                  ),
                  SizedBox(width: 10.w),
                  IconButton(
                    tooltip: 'Settings',
                    icon: const Icon(Icons.settings, color: fbDarkPrimary),
                    onPressed: () => _openSettings(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _openSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Settings & Preferences',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: fbDarkPrimary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(),
                  const ListTile(
                    leading: Icon(Icons.person_outline),
                    title: Text('User Profile'),
                    subtitle: Text('Connected with DummyJSON'),
                  ),
                  const Divider(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.logout),
                      label: const Text('Sign Out'),
                      onPressed: () async {
                        await UserService().logout();
                        if (!context.mounted) return;
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/signin',
                          (route) => false,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

/* ================= TAB BAR DELEGATE ================= */

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.white, child: tabBar);
  }

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) => false;
}

/* ================= POSTS TAB ================= */

class _PostsTab extends StatefulWidget {
  final String displayName;
  final int userId;

  const _PostsTab({required this.displayName, required this.userId});

  @override
  State<_PostsTab> createState() => _PostsTabState();
}

class _PostsTabState extends State<_PostsTab> {
  final PostService _postService = PostService();
  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  @override
  void didUpdateWidget(covariant _PostsTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId) {
      _loadPosts();
    }
  }

  void _loadPosts() {
    _postsFuture = _postService.getPostsByUserId(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
      future: _postsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final posts = snapshot.data ?? [];

        if (posts.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Text(
                'No posts found for user #${widget.userId}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14.sp),
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return PostCard(
              postId: post.id,
              userName: widget.displayName,
              postContent: post.body,
              numOfLikes: post.likes,
              date: 'Post #${post.id}',
              profileImageUrl: '',
              imageUrl: '',
            );
          },
        );
      },
    );
  }
}

/* ================= ABOUT TAB ================= */

class _AboutTab extends StatelessWidget {
  const _AboutTab();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: const Text(
        "BS Information Technology - Mobile & Web Application\n\n"
        "📍 Philippines\n"
        "📧 lawrenz123@gmail.com",
      ),
    );
  }
}

class _PhotosTab extends StatelessWidget {
  const _PhotosTab();

  @override
  Widget build(BuildContext context) {
    final List<String> photoUrls = [
      'https://i.pinimg.com/736x/5f/b3/9f/5fb39f97fc926b5cf8c52ae3c9fa290b.jpg',
      'https://i.pinimg.com/1200x/4f/c7/4b/4fc74b0567a6de8369479c14746c2216.jpg',
      'https://i.pinimg.com/736x/e1/cf/42/e1cf4269e3ebb9f6760f41446dd02830.jpg',
      'https://i.pinimg.com/1200x/72/63/71/7263711ed659d0aca809ae62996bd8b3.jpg',
      'https://i.pinimg.com/736x/63/dd/04/63dd0428444af729574803ce65be4f29.jpg',
      'https://i.pinimg.com/736x/64/ba/ec/64baec6800c18771911873528d7114cc.jpg',
      'https://i.pinimg.com/1200x/96/14/a2/9614a2efd299f51be9bec6de526c1f73.jpg',
      'https://i.pinimg.com/1200x/94/f7/1c/94f71c5be81cbfb45e3fcb10195be61a.jpg',
    ];

    return GridView.builder(
      padding: EdgeInsets.all(12.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.h,
      ),
      itemCount: photoUrls.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: CachedNetworkImage(
            imageUrl: photoUrls[index],
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                Container(color: Colors.grey.shade200),
            errorWidget: (context, url, error) =>
                Container(color: Colors.grey.shade300),
          ),
        );
      },
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;

  const _Stat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      height: 4,
      width: 4,
      decoration: const BoxDecoration(
        color: Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}
