import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/constant.dart';

class ProfileController extends GetxController {
  var userProfile = Rxn<QueryDocumentSnapshot>();

  final emailCon = TextEditingController();
  final oldPasswordCon = TextEditingController();
  final newPasswordCon = TextEditingController();
  final reNewPasswordCon = TextEditingController();

  var isLoading = false.obs;

  getUserProfile() {
    isLoading.value = true;

    fDb.collection("users").get().then((value) {
      isLoading.value = false;

      userProfile.value = value.docs.first;

      emailCon.text = userProfile.value?.get("email") ?? "";
    });
  }

  updateEmail() {
    fDb
        .collection("users")
        .doc(userProfile.value?.id)
        .update({'email': emailCon.text}).then((value) {
      Get.back();
      getUserProfile();
      return Get.snackbar("Success", "Email changed",
          backgroundColor: CupertinoColors.activeGreen,
          colorText: CupertinoColors.white);
    });
  }

  updatePassword() {
    if (userProfile.value?.get("password") != oldPasswordCon.text) {
      Get.snackbar("Validation Error", "Old password incorrect ",
          backgroundColor: Colors.red, colorText: CupertinoColors.white);
    } else if (newPasswordCon.text != reNewPasswordCon.text) {
      Get.snackbar("Validation Error", "Password re input password don't match",
          backgroundColor: Colors.red, colorText: CupertinoColors.white);
    } else {
      fDb
          .collection("users")
          .doc(userProfile.value?.id)
          .update({'password': newPasswordCon.text}).then((value) {

            oldPasswordCon.clear();
            newPasswordCon.clear();
            reNewPasswordCon.clear();

            getUserProfile();

        Get.back();
        return Get.snackbar("Success", "Password changed",
            backgroundColor: CupertinoColors.activeGreen,
            colorText: CupertinoColors.white);
      });
    }
  }
}
