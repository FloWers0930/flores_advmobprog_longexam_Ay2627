import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flores_mobprog/screens/signin_screen.dart';
import 'package:flores_mobprog/screens/home_screen.dart';
import 'package:flores_mobprog/services/user_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final userService = UserService();
  final isLoggedIn = await userService.isLoggedIn();
  final savedUser = await userService.getSavedUser();

  runApp(
    FacebookReplication(
      initialRoute: isLoggedIn ? '/home' : '/signin',
      initialUsername: savedUser?.username ?? 'User',
    ),
  );
}

class FacebookReplication extends StatelessWidget {
  final String initialRoute;
  final String initialUsername;

  const FacebookReplication({
    super.key,
    this.initialRoute = '/signin',
    this.initialUsername = 'User',
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 715),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Facebook Replication',
          initialRoute: initialRoute,

          /// STATIC ROUTES
          routes: {
            '/': (context) => const SigninScreen(),
            '/signin': (context) => const SigninScreen(),
            '/login': (context) => const SigninScreen(),
          },

          /// DYNAMIC ROUTES
          onGenerateRoute: (settings) {
            if (settings.name == '/home') {
              return MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              );
            }
            return null;
          },
        );
      },
    );
  }
}
