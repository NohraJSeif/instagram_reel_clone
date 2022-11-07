import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/login_functions.dart';
import '../screens/signup_screen.dart';
import './home_screen.dart';
import './loading_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  bool isLoading = false;

  void onLogin() async {
    if (email.text.isNotEmpty && password.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      bool isLoginSuccessful =
          await LoginFunctions.login(email.text, password.text);

      if (isLoginSuccessful) {
        print("Login successful");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => const HomeScreen(),
            ),
            (route) => false);
      } else {
        print("Something went wrong");
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const LoadingScreen()
        : Scaffold(
            body: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Instagram",
                    style: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  customTextField('Email', email, false),
                  customTextField('Password', password, true),
                  SizedBox(
                    height: 20.h,
                  ),
                  customButton("Login"),
                ],
              ),
            ),
            bottomNavigationBar: SizedBox(
              height: 60.sp,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "New User? ",
                    style: TextStyle(
                      fontSize: 15.sp,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => SignupScreen()));
                    },
                    child: Text(
                      "Signup",
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget customButton(String text) {
    return InkWell(
      onTap: onLogin,
      child: Container(
        height: 40.h,
        width: 320.w,
        color: Colors.blue,
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget customTextField(
      String hintText, TextEditingController controller, bool obscureText) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 20,
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
