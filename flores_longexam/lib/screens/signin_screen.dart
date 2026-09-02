import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants.dart';
import '../services/user_service.dart';
import '../widgets/custom_dialogs.dart';
import '../widgets/custom_font.dart';
import '../widgets/custom_inkwell_button.dart';
import '../widgets/custom_textformfield.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final UserService _userService = UserService();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      customDialog(
        context,
        title: 'Error',
        content: 'Please enter both username and password.',
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await _userService.login(username, password);
      if (!mounted) return;
      setState(() => _isLoading = false);

      Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments: user.username,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);

      // Fallback demo credentials
      if (username == 'user' && password == 'user') {
        Navigator.pushReplacementNamed(context, '/home', arguments: username);
        return;
      }

      customDialog(
        context,
        title: 'Login Failed',
        content: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(28),
              vertical: 24.h,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20.h),

                  // Brand Logo
                  Image.asset(
                    'assets/images/NUCCITLogo_Black.png',
                    width: 320.w,
                    height: 100.h,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/images/logo.png',
                      width: 320.w,
                      height: 100.h,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.school,
                        size: 90.sp,
                        color: fbDarkPrimary,
                      ),
                    ),
                  ),

                  SizedBox(height: 40.h),

                  // Username Input
                  CustomTextFormField(
                    height: ScreenUtil().setHeight(12),
                    width: ScreenUtil().setWidth(12),
                    controller: usernameController,
                    fontSize: ScreenUtil().setSp(16),
                    fontColor: fbDarkPrimary,
                    hintText: 'Username (e.g. emilys)',
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Enter your username'
                        : null,
                    onSaved: (value) =>
                        usernameController.text = value?.trim() ?? '',
                  ),

                  SizedBox(height: 16.h),

                  // Password Input
                  CustomTextFormField(
                    height: ScreenUtil().setHeight(12),
                    width: ScreenUtil().setWidth(12),
                    controller: passwordController,
                    fontSize: ScreenUtil().setSp(16),
                    fontColor: fbDarkPrimary,
                    hintText: 'Password (e.g. emilyspass)',
                    isObscure: _obscurePassword,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Enter your password'
                        : null,
                    onSaved: (value) =>
                        passwordController.text = value?.trim() ?? '',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: fbDarkPrimary,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),

                  SizedBox(height: 28.h),

                  // Login Button
                  CustomInkwellButton(
                    buttonName: _isLoading ? 'Signing in...' : 'Login',
                    height: ScreenUtil().setHeight(44),
                    width: ScreenUtil().screenWidth,
                    fontSize: ScreenUtil().setSp(16),
                    onTap: () {
                      if (_isLoading) return;
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        login();
                      }
                    },
                  ),

                  SizedBox(height: 20.h),

                  // Helper text
                  CustomFont(
                    text: 'Demo credentials: emilys / emilyspass',
                    fontSize: ScreenUtil().setSp(12),
                    color: Colors.grey,
                  ),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
