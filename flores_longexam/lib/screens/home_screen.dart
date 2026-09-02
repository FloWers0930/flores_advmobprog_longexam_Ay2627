import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Added for local storage
import '../constants.dart';
import '../widgets/custom_font.dart';
import 'newsfeed_screen.dart';
import 'notification_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  // 1. Removed the required username from the constructor
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  // 2. Created a local state variable to hold the username
  String _username = 'Loading...';

  @override
  void initState() {
    super.initState();
    // Ensures SharedPreferences is loaded after the initial frame renders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  // 3. Fetch the saved username from DummyJSON login
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'FlowBook User';
    });
  }

  String _getTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'FlowBook';
      case 1:
        return 'Notifications';
      case 2:
        return _username; // 4. Uses the fetched username
      default:
        return 'FlowBook';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).appBarTheme.backgroundColor ??
            Theme.of(context).cardColor,
        elevation: 2,
        automaticallyImplyLeading: false,
        title: CustomFont(
          text: _getTitle(),
          fontSize: ScreenUtil().setSp(22),
          color:
              Theme.of(context).appBarTheme.foregroundColor ??
              Theme.of(context).textTheme.bodyLarge?.color ??
              Colors.black,
          fontFamily: 'Klavika',
          fontWeight: FontWeight.bold,
        ),
        centerTitle: false,
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (page) {
          setState(() => _selectedIndex = page);
        },
        children: [
          const NewsFeedScreen(),
          const NotificationScreen(),
          // Passes the fetched username to your profile screen
          ProfileScreen(username: _username),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:
            Theme.of(context).bottomNavigationBarTheme.backgroundColor ??
            Theme.of(context).cardColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF1877F2),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: _onTappedBar,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  void _onTappedBar(int value) {
    setState(() => _selectedIndex = value);
    _pageController.jumpToPage(value);
  }
}
