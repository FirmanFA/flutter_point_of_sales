import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../constant/constant.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  var emailCon = TextEditingController();
  var passwordCon = TextEditingController();

  Future<bool> login(String email, String password) async {
    bool isLogin = false;
    isLoading.value = true;
    await Future.delayed(Duration(milliseconds: 100));
    /// get data in collection 'users' with email and password from textfield
    await fDb
        .collection('users')
        .where('email', isEqualTo: email)
        .where('password', isEqualTo: password)
        .get()
        .then((querySnapshot) {
      /// return true if data exist, false otherwise
      if (querySnapshot.docs.isNotEmpty) {
        isLogin = true;
      } else {
        isLogin = false;
      }
    });
    isLoading.value = false;
    return isLogin;
  }
}
