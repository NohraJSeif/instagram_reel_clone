import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../const.dart';
import '../models/profile_update_functions.dart';
import '../models/user_model.dart';
import './loading_screen.dart';
import './profile_screen.dart';

class ProfileUpdateScreen extends StatefulWidget {
  final UserModel userModel;
  const ProfileUpdateScreen({
    super.key,
    required this.userModel,
  });

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final TextEditingController name = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController bio = TextEditingController();
  final TextEditingController addLink = TextEditingController();
  File? profileImage;
  bool isLoading = false;

  void pickImage() async {
    final pickedImage =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      profileImage = File(pickedImage.path);
      setState(() {});
    }
  }

  void onSavingDetails() async {
    if (name.text.isNotEmpty && username.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      String profileImageUrl = "";
      if (profileImage != null) {
        String imageId = generateId();
        profileImageUrl =
            await ProfileUpdateFunctions.uploadImage(profileImage!, imageId) ??
                "";
      }
      Map<String, dynamic> userDetails = {
        'name': name.text,
        'username': username.text,
        'bio': bio.text,
        'add_link': addLink.text,
        "profile_image": profileImageUrl.isNotEmpty
            ? profileImageUrl
            : widget.userModel.addLink,
      };

      ProfileUpdateFunctions.updateUserProfile(userDetails);
      setState(() {
        isLoading = false;
      });
    } else {
      print("Username and name are required");
    }
  }

  void initState() {
    super.initState();
    setUserDetails();
  }

  void setUserDetails() {
    name.text = widget.userModel.name;
    username.text = widget.userModel.username;
    bio.text = widget.userModel.bio;
    addLink.text = widget.userModel.addLink;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const LoadingScreen()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: const Text(
                "Edit Profile",
                style: TextStyle(color: Colors.black),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        userId: FirebaseAuth.instance.currentUser!.uid,
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.black,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: onSavingDetails,
                  icon: const Icon(
                    Icons.done,
                    color: Colors.blue,
                  ),
                )
              ],
            ),
            body: SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      height: 90.h,
                      width: 90.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                        image: DecorationImage(
                          image: profileImage != null
                              ? FileImage(profileImage!) as ImageProvider
                              : NetworkImage(
                                  widget.userModel.profileImage,
                                ),
                        ),
                      ),
                      // child: Icon(
                      //   Icons.account_circle,
                      //   size: 90.sp,
                      // ),
                    ),
                    TextButton(
                      onPressed: pickImage,
                      child: Text(
                        "Change Profile photo",
                        style: TextStyle(fontSize: 18.sp),
                      ),
                    ),
                    customTextField('Name', name),
                    customTextField('Username', username),
                    customTextField('Bio', bio),
                    customTextField('Add link', addLink),
                  ],
                ),
              ),
            ),
          );
  }

  Widget customTextField(String hintText, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.all(10.sp),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
        ),
      ),
    );
  }
}
