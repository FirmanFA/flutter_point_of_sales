import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/constant.dart';

class ProfileController extends GetxController {

  /// variable to store profile data
  var userProfile = Rxn<QueryDocumentSnapshot>();

  /// controller for input field
  final emailCon = TextEditingController();
  final oldPasswordCon = TextEditingController();
  final newPasswordCon = TextEditingController();
  final reNewPasswordCon = TextEditingController();

  var isLoading = false.obs;

  /// function to get profile
  getUserProfile() {
    isLoading.value = true;

    /// get profile data from firebase
    fDb.collection("users").get().then((value) {
      isLoading.value = false;

      /// set the profile
      userProfile.value = value.docs.first;

      /// set the input field
      emailCon.text = userProfile.value?.get("email") ?? "";
    });
  }

  /// function to update email
  updateEmail() {

    /// update email from firebase
    fDb
        .collection("users")
        .doc(userProfile.value?.id)
        .update({'email': emailCon.text}).then((value) {
      Get.back();
      getUserProfile();
      ///show success message when done
      return Get.snackbar("Success", "Email changed",
          backgroundColor: CupertinoColors.activeGreen,
          colorText: CupertinoColors.white);
    });
  }

  /// function to update password
  updatePassword() {

    /// validate user input before change password
    if (userProfile.value?.get("password") != oldPasswordCon.text) {
      Get.snackbar("Validation Error", "Old password incorrect ",
          backgroundColor: Colors.red, colorText: CupertinoColors.white);
    } else if (newPasswordCon.text != reNewPasswordCon.text) {
      Get.snackbar("Validation Error", "Password re input password don't match",
          backgroundColor: Colors.red, colorText: CupertinoColors.white);
    } else {

      /// update user password
      fDb
          .collection("users")
          .doc(userProfile.value?.id)
          .update({'password': newPasswordCon.text}).then((value) {

            oldPasswordCon.clear();
            newPasswordCon.clear();
            reNewPasswordCon.clear();

            getUserProfile();

        Get.back();
        /// show success message when done
        return Get.snackbar("Success", "Password changed",
            backgroundColor: CupertinoColors.activeGreen,
            colorText: CupertinoColors.white);
      });
    }
  }
}
