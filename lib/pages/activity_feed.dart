import 'package:flutter/material.dart';
import 'package:my_app/constent/controllers.dart';
import 'package:my_app/models/comment_model.dart';
import 'package:my_app/models/user.dart';

import 'package:my_app/widgets/feed.dart';
import 'package:my_app/widgets/header.dart';

class ActivityFeed extends StatelessWidget {
  final String? currentUser;
  final UserModel userModel;
   const ActivityFeed({Key? key,this.currentUser,required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.orange,
        appBar: header(context, titleText: "Activity Feed"),
        body: StreamBuilder<List<ActivityFeedModel>>(
          stream: activityFeedController.getAllFeeds(currentUser),
          builder:(_,snapshot){
             if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Loading");
                    }
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Feed(
                            activityFeedModel: snapshot.data![index],user: userModel,
                          );
                        });
          } ,)

       
        );
  }
}
