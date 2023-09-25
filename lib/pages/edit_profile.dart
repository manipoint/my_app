import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:image/image.dart' as im;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:my_app/constent/controllers.dart';
import 'package:my_app/constent/firebase.dart';
import 'package:my_app/widgets/custom_text.dart';
import 'package:my_app/widgets/progress.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? file;
  bool isUploading = false;
  ImagePicker imagePicker = ImagePicker();
  dynamic _pickImageError;

  final Rx<bool> isLoading = false.obs;
  final Rx<bool> displayNameValid = true.obs;
  final Rx<bool> bioValid = true.obs;
  handleTakePhoto() async {
    Navigator.pop(context);
    try {
      XFile? image = await imagePicker.pickImage(
        source: ImageSource.camera,
      );
      File imageFile = File(image!.path);
      setState(() {
        file = imageFile;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
      Get.snackbar("Error", _pickImageError.toString());
    }
  }

  handleChooseFromGallery() async {
    Navigator.pop(context);
    try {
      final image = await imagePicker.pickImage(source: ImageSource.gallery);
      File imageFile = File(image!.path);
      setState(() {
        file = imageFile;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
      Get.snackbar("Error", _pickImageError.toString());
      print(_pickImageError);
    }
  }

  selectImage(parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: const Text("Create Post"),
          children: <Widget>[
            SimpleDialogOption(
                child: const Text("Photo with Camera"),
                onPressed: handleTakePhoto),
            SimpleDialogOption(
                child: const Text("Image from Gallery"),
                onPressed: handleChooseFromGallery),
            SimpleDialogOption(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  clearImage() {
    setState(() {
      file = null;
    });
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    im.Image? imageFile = im.decodeImage(File(file!.path).readAsBytesSync());
    final compressedImageFile =
        File('$path/img_${authController.userModel.value.username}.jpg')
          ..writeAsBytesSync(im.encodeJpg(imageFile!, quality: 85));
    setState(() {
      file = compressedImageFile;
    });
  }

  Future<String> uploadImage(imageFile) async {
    UploadTask uploadTask = storageRef
        .child("profile img")
        .child("${authController.userModel.value.username}.jpg")
        .putFile(File(imageFile.path));
    TaskSnapshot storageSnap = await uploadTask.then((value) => value);
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  handleSubmit() async {
    setState(() {
      isUploading = true;
    });
    await compressImage();
    String mediaUrl = await uploadImage(file);
    authController.updateUserData({"photoUrl": mediaUrl});

    setState(() {
      file = null;
      isUploading = false;
    });
  }

  Scaffold buildUploadForm() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: clearImage),
        title: const Text(
          "Caption Post",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          // ignore: deprecated_member_use
          TextButton(
            onPressed: isUploading ? null : () => handleSubmit(),
            child: const Text(
              "Update",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        height: 220.0,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Center(
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: FileImage(File(file!.path)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildEditScreen() {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            "Edit Profile",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.done,
                size: 30.0,
                color: Colors.green,
              ),
            ),
          ],
        ),
        body: isLoading.value
            ? circularProgress()
            : ListView(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 16.0,
                          bottom: 8.0,
                        ),
                        child: CircleAvatar(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 60.0, top: 55),
                            child: IconButton(
                                onPressed: () => selectImage(context),
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.deepOrange,
                                )),
                          ),
                          radius: 50.0,
                          backgroundImage: CachedNetworkImageProvider(
                              authController.userModel.value.photoUrl!),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            buildDisplayNameField(context),
                            buildBioField(context),
                          ],
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                        ),
                        onPressed: () => updateProfileData(),
                        child: CustomText(
                          text: "Edit Profile",
                          color: Theme.of(context).primaryColor,
                          size: 20,
                          weight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                          ),
                          onPressed: () => authController.logoutGoogle(),
                          icon: const Icon(Icons.cancel, color: Colors.white),
                          label: const Text(
                            "Logout",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ));
  }

  buildDisplayNameField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
            padding: EdgeInsets.only(left: 12.0),
            child: Text(
              "Display Name",
              style: TextStyle(color: Colors.grey),
            )),
        Container(
          width: MediaQuery.of(context).size.width * .9,
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.withOpacity(.3),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: TextField(
              controller: authController.displayName,
              decoration: InputDecoration(
                hintText: "Update Display Name",
                border: InputBorder.none,
                errorText:
                    displayNameValid.value ? null : "Display Name too short",
              ),
            ),
          ),
        )
      ],
    );
  }

  buildBioField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            "Bio",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * .9,
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.withOpacity(.3),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: TextField(
              controller: authController.bio,
              decoration: InputDecoration(
                hintText: "Update Bio",
                border: InputBorder.none,
                errorText: bioValid.value ? null : "Bio too long",
              ),
            ),
          ),
        )
      ],
    );
  }

  updateProfileData() {
    authController.displayName.text.trim().length < 3 ||
            authController.displayName.text.isEmpty
        ? displayNameValid.value = false
        : displayNameValid.value = true;
    authController.bio.text.trim().length > 200
        ? bioValid.value = false
        : bioValid.value = true;
    if (displayNameValid.value && bioValid.value) {
      authController.updateUserData({
        "displayName": authController.displayName.text,
        "bio": authController.bio.text,
      });
      Get.snackbar("Update", "Profile Update SuccessFully");
    }
  }

  @override
  Widget build(BuildContext context) {
    return file == null ? buildEditScreen() : buildUploadForm();
  }
}
