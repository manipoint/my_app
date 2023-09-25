import 'package:get/get.dart';
import 'package:my_app/constent/firebase.dart';
import 'package:my_app/models/comment_model.dart';

class ActivityFeedController extends GetxController {
  static ActivityFeedController instance = Get.find();


  Stream<List<ActivityFeedModel>> getAllFeeds(String? id) {
    return
    activityFeedRef
        .doc(id)
        .collection("feedItems")
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .map((event) => event.docs
            .map((e) => ActivityFeedModel.fromJson(e.data()))
            .toList());
   
  }
}
