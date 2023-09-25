import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_app/constent/firebase.dart';
import 'package:my_app/models/user.dart';
import 'package:my_app/pages/auth/auth.dart';
import 'package:my_app/pages/home.dart';
import 'package:my_app/widgets/progress.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  late Rx<User?> firebaseUser;
  RxList<UserModel> users = RxList<UserModel>();
  RxList<UserModel> limtedUsers = RxList<UserModel>();
  

  Rx<UserModel> userModel = UserModel().obs;
   Rx<UserModel> followerModel = UserModel().obs;
  final DateTime timestamp = DateTime.now();

  //signin / up
  TextEditingController userName = TextEditingController();
  TextEditingController displayName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController bio = TextEditingController();

  //search
  TextEditingController searchController = TextEditingController();
  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());
    users.bindStream(getAllUsers());
    limtedUsers.bindStream(getLimitedUser());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => AuthenticationScreen());
    } else {
      userModel.bindStream(listenToUser());
      Get.offAll(() => Home());
    }
  }

  loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final authResult = await auth.signInWithCredential(credential);

      final User? user = authResult.user;
      assert(!user!.isAnonymous);
      // ignore: unnecessary_null_comparison
      assert(await user!.getIdToken() != null);
      final User? currentUser = auth.currentUser;
      assert(user!.uid == currentUser!.uid);
     usersRef.doc(currentUser!.uid).set({
        "id": currentUser.uid,
        "photoUrl": currentUser.photoURL,
        "email": currentUser.email,
        "displayName": currentUser.displayName,
        "userName": currentUser.displayName,
        "bio": "",
        "timestamp": timestamp
      });

       

      Get.to(Home()); // navigate to your wanted page
      return;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logoutGoogle() async {
    await googleSignIn.signOut();
    await auth.signOut();
    Get.to(() =>
        AuthenticationScreen()); // navigate to your wanted page after logout.
  }

  void signIn() async {
    try {
      circularProgress();
      await auth
          .signInWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim())
          .then((result) {
        _clearControllers();
      });
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar("Sign In Failed", "Try again");
    }
  }

  void signUp() async {
    circularProgress();
    try {
      await auth
          .createUserWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim())
          .then((result) {
        String _userId = result.user!.uid;
        _addUserToFirestore(_userId);
        _clearControllers();
      });
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar("Signup Failed", "Try again");
    }
  }

  _clearControllers() {
    userName.clear();
    displayName.clear();
    email.clear();
    password.clear();
    bio.clear();
  }

  Stream<UserModel> listenToUser() =>usersRef 
      .doc(firebaseUser.value!.uid)
      .snapshots()
      .map((query) => UserModel.fromJson(query.data()!));

  _addUserToFirestore(String userId) {
    usersRef.doc(userId).set({
      "id": userId,
      "userName": userName.text,
      "displayName": displayName.text,
      "email": email.text.toLowerCase().trim(),
      "password": password.text.trim(),
      "bio": bio.text,
      "photoUrl": "",
    });
  }

   getUsers() {
    usersRef
        .get()
        .then((value) => value.docs.map((e) => UserModel.fromJson(e.data())));
  }
 

  Stream<List<UserModel>> getAllUsers() =>
      usersRef.snapshots().map((query) =>
          query.docs.map((e) => UserModel.fromJson(e.data())).toList());

  updateUserData(Map<String, dynamic> data) {
    usersRef
        .doc(firebaseUser.value!.uid)
        .update(data);
  }

  Stream<List<UserModel>> getLimitedUser() {
    return usersRef
        .orderBy('timestamp', descending: true)
        .limit(30)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => UserModel.fromJson(e.data())).toList());
  }
}
