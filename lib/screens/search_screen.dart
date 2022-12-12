import 'package:flutter/material.dart';

import '../models/search_functions.dart';
import '../models/user_model.dart';
import './profile_screen.dart';

class SearchScreen extends SearchDelegate {
  List<UserModel> usersModel = [];

  void searchUser() async {
    usersModel = [];
    usersModel = await SearchFunctions.searchUsers(query) ?? [];
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: const Icon(Icons.close),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return const BackButton();
  }

  @override
  Widget buildResults(BuildContext context) {
    searchUser();
    return ListView.builder(
        itemCount: usersModel.length,
        itemBuilder: (context, index) {
          return ListTile(
              onTap: () {},
              leading: const CircleAvatar(
                backgroundColor: Colors.grey,
              ),
              title: Text(usersModel[index].username));
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    searchUser();
    return ListView.builder(
        itemCount: usersModel.length,
        itemBuilder: (context, index) {
          return ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfileScreen(
                      userId: usersModel[index].uid,
                    ),
                  ),
                );
              },
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(usersModel[index].profileImage),
              ),
              title: Text(usersModel[index].username));
        });
  }
}
