import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_reel_clone/models/signup_functions.dart';

import '../screens/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool isLoading = false;

  void onCreateAccount() async {
    if (email.text.isNotEmpty && password.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      bool isAccountCreatedSuccessfully =
          await SignupFunctions.createAccount(email.text, password.text);

      if (isAccountCreatedSuccessfully) {
        print("Account Created Successfully");
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
    return Scaffold(
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
            customTextField('Email', email),
            customTextField('Password', password),
            SizedBox(
              height: 20.h,
            ),
            customButton("Create Account"),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 60.sp,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Already a User? ",
              style: TextStyle(
                fontSize: 15.sp,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => LoginScreen()));
              },
              child: Text(
                "Login",
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
      onTap: onCreateAccount,
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

  Widget customTextField(String hintText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 20,
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
