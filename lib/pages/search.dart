import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/constent/controllers.dart';
import 'package:my_app/models/user.dart';
import 'package:my_app/pages/profile.dart';

class SearchPage extends StatelessWidget {
  List<UserModel> users = authController.users;
  RxList<UserModel> searchResults = <UserModel>[].obs;
  
  Widget getLowerLayer() {
    return Container(
      margin: const EdgeInsets.only(top: 60),
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey.withOpacity(.3),
            ),
            child: TextField(
              controller: authController.searchController,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  List<UserModel> tempList = <UserModel>[];
                  for (var user in users) {
                    if (user.displayName!.toLowerCase().contains(value)) {
                      tempList.add(user);
                    }
                  }
                  searchResults.clear();
                  searchResults.addAll(tempList);
                  return;
                } else {
                  searchResults.clear();
                  searchResults.addAll(users);
                }
              },
              cursorColor: Colors.grey,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search),
                  suffix: TextButton(
                      onPressed: () {
                        authController.searchController.clear();
                        searchResults.clear();
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(right: 12.0),
                        child: Text(
                          'Clear',
                          style: TextStyle(color: Colors.red),
                        ),
                      ))),
            ),
          ),
          Flexible(
            child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (_, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListTile(
                      tileColor: Colors.green.shade100,
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: CachedNetworkImageProvider(
                            searchResults[index].photoUrl!),
                      ),
                      onTap: () => Get.to(() => Profile(
    
                            user: searchResults[index],
                          )),
                      title: Text(searchResults[index].displayName!),
                      subtitle: Text(
                        searchResults[index].email!,
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ))),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => getLowerLayer()),
    );
  }
}
