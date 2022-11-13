import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/profile_functions.dart';
import '../models/user_model.dart';
import './profile_update_screen.dart';
import './loading_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? userModel;

  void initState() {
    super.initState();
    getCurrentUserDetails();
  }

  void getCurrentUserDetails() async {
    userModel = await ProfileFunctions.getUserDetails();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: userModel == null
          ? LoadingScreen()
          : Scaffold(
              body: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            userModel!.username,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 90.h,
                          width: 90.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                            image: DecorationImage(
                              image: NetworkImage(userModel!.profileImage),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        showDetails("Posts", userModel!.posts.toString()),
                        showDetails(
                            "Followers", userModel!.followers.toString()),
                        showDetails(
                            "Following", userModel!.following.toString()),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          userModel!.name,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          userModel!.bio,
                          style: TextStyle(
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: () async {
                            Uri uri = Uri.parse(userModel!.addLink);
                            if (await canLaunchUrl(uri)) {
                              launchUrl(uri);
                            } else {
                              print("Can not launch url");
                            }
                          },
                          child: Text(
                            userModel!.addLink,
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 15.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    customButton(true),
                    SizedBox(
                      height: 20.h,
                    ),
                    Expanded(
                      child: GridView.builder(
                        itemCount: 18,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemBuilder: (context, index) {
                          return SizedBox(
                            child: Image.network(
                              "https://wonderfulengineering.com/wp-content/uploads/2016/01/nature-wallpapers-38.jpg",
                              fit: BoxFit.fill,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget customButton(bool isCurrentProfile) {
    return InkWell(
      onTap: () {
        if (isCurrentProfile) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProfileUpdateScreen(userModel: userModel!),
            ),
          );
        } else {
          // Follow instruction
        }
      },
      child: Container(
        height: 30.h,
        width: 310.w,
        decoration: BoxDecoration(
          color: isCurrentProfile ? Colors.grey[300] : Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          isCurrentProfile ? "Edit Profile" : "Follow",
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            color: isCurrentProfile ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget showDetails(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
