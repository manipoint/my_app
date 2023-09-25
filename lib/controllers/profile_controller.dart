// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:my_app/constent/firebase.dart';
// import 'package:my_app/models/user.dart';

// class ProfileController extends GetxController {
//   static ProfileController instance = Get.find();

//   RxInt postCount = 0.obs;
//   RxInt followerCount = 0.obs;
//   RxInt followingCount = 0.obs;
//   Rx<bool> isFollowing = true.obs;

//   Future<bool> checkIfFollowing() async {
//     DocumentSnapshot ref = await followersRef
//         .doc(auth.currentUser!.uid)
//         .collection('userFollowers')
//         .doc()
//         .get();

//     return isFollowing.value = ref.exists;
//   }

//   Future<int> getProfilePosts(UserModel user) async {
//     QuerySnapshot snapshot = await postsRef
//         .doc(user.id)
//         .collection('userPosts')
//         .orderBy('timestamp', descending: true)
//         .get();

//     return postCount.value = snapshot.docs.length;
//   }

//   Future<int> getFollowers() async {
//     QuerySnapshot snapshot = await followersRef
//         .doc(auth.currentUser!.uid)
//         .collection('userFollowers')
//         .get();
//     return followerCount.value = snapshot.docs.length;
//   }

//   Future<int> getFollowing() async {
//     QuerySnapshot snapshot = await followingRef
//         .doc(auth.currentUser!.uid)
//         .collection('userFollowing')
//         .get();
//     return followingCount.value = snapshot.docs.length;
//   }

//   handleFollowUser(UserModel user) {
//     getFollowers();
//     getFollowing();
//     isFollowing.value = true;
//     // Make auth user follower of THAT user (update THEIR followers collection)
//     followersRef
//         .doc(user.id)
//         .collection('userFollowers')
//         .doc(auth.currentUser!.uid)
//         .set({});
// // Put THAT user on YOUR following collection (update your following collection)
//     followingRef
//         .doc(auth.currentUser!.uid)
//         .collection('userFollowing')
//         .doc(user.id)
//         .set({});
//     // add activity feed item for that user to notify about new follower (us)
//     activityFeedRef
//         .doc(user.id)
//         .collection('feedItems')
//         .doc(auth.currentUser!.uid)
//         .set({
//       "type": "follow",
//       "ownerId": user.id,
//       "username": user.username,
//       "userId": auth.currentUser!.uid,
//       "userProfileImg": user.photoUrl,
//       "timestamp": DateTime.now(),
//     });
//     update();
//   }

//   handleUnfollowUser(UserModel user) async {
//     isFollowing.value = false;
//     followersRef
//         .doc(user.id)
//         .collection('userFollowers')
//         .doc(auth.currentUser!.uid)
//         .get()
//         .then((value) {
//       if (value.exists) {
//         value.reference.delete();
//       }
//     });
//     followingRef
//         .doc(auth.currentUser!.uid)
//         .collection('userFollowing')
//         .doc(user.id)
//         .get()
//         .then((value) {
//       if (value.exists) {
//         value.reference.delete();
//       }
//     });

//     activityFeedRef
//         .doc(user.id)
//         .collection('feedItems')
//         .doc(auth.currentUser!.uid)
//         .get()
//         .then((value) {
//       if (value.exists) {
//         value.reference.delete();
//       }
//     });
//     await getFollowing();
//     await getFollowers();
//     update();
//   }
// }
