  // lib/screens/splash_screen.dart
  import 'package:flutter/material.dart';
  import 'package:flores_mobprog/services/user_service.dart';
  import 'package:flutter/cupertino.dart';
  import 'package:flutter_screenutil/flutter_screenutil.dart';

  class SplashScreen extends StatefulWidget {
    const SplashScreen({super.key});

    @override
    State<SplashScreen> createState() => _SplashScreenState();
  }

  class _SplashScreenState extends State<SplashScreen> {
    final UserService _userService = UserService();

    @override
    void initState() {
      super.initState();
      _checkAuthStatus();
    }

    Future<void> _checkAuthStatus() async {
      await Future.delayed(const Duration(seconds: 2));
      final bool isAuth = await _userService.isLoggedIn();
      if (!mounted) return;
      if (isAuth) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/signin');
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png', height: 120.h),
              SizedBox(height: 32.h),
              const CupertinoActivityIndicator(radius: 20),
            ],
          ),
        ),
      );
    }
  }
