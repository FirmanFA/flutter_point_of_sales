import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../constant/constant.dart';

class LoginController extends GetxController {

  var isLoading = false.obs;
  var emailCon = TextEditingController();
  var passwordCon = TextEditingController();

  Future<bool> login(String email, String password) async {
    //do login

    bool isLogin = false;

    isLoading.value = true;

    await Future.delayed(Duration(milliseconds: 100));

    await fDb
        .collection('users')
        .where('email', isEqualTo: email)
        .where('password', isEqualTo: password)
        .get()
        .then((querySnapshot) {

      // print("Successfully completed");
      // for (var docSnapshot in querySnapshot.docs) {
      //   print('${docSnapshot.id} => ${docSnapshot.data()}');
      // }
      //
      //     debugPrint("data doccs ${querySnapshot}");

      if (querySnapshot.docs.isNotEmpty) {
        isLogin =  true;
      } else {
        isLogin =  false;
      }
    });
    isLoading.value =false ;
    return isLogin;
  }
}
