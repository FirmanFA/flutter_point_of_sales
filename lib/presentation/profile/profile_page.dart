import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:point_of_sales/presentation/profile/profile_controller.dart';
import 'package:point_of_sales/widget/default_app_bar.dart';

import '../../constant/constant.dart';
import '../../widget/text_input_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    controller.getUserProfile();

    return Scaffold(
        appBar: defaultAppBar("Profil"),
        body: Obx(
          () => Padding(
            padding:
                const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 50),
            child: controller.isLoading.value
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          Get.defaultDialog(
                              title: "Ubah Email",
                              confirmTextColor: Colors.white,
                              textConfirm: "Ubah",
                              onConfirm: () {
                                controller.updateEmail();
                              },
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 12,
                                  ),
                                  CustomTextInput(
                                    label: "Email",
                                    hint: "",
                                    controller: controller.emailCon,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                ],
                              ));
                        },
                        padding: EdgeInsets.all(12),
                        color: primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          'Ubah Email',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      MaterialButton(
                        onPressed: () {
                          Get.defaultDialog(
                              title: "Ubah Password",
                              confirmTextColor: Colors.white,
                              textConfirm: "Ubah",
                              onConfirm: () {
                                controller.updatePassword();
                              },
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 12,
                                  ),
                                  CustomTextInput(
                                    label: "Old Password",
                                    hint: "",
                                    isPassword: true,
                                    controller: controller.oldPasswordCon,
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  CustomTextInput(
                                    label: "New Password",
                                    hint: "",
                                    isPassword: true,
                                    controller: controller.newPasswordCon,
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  CustomTextInput(
                                    label: "ReType New Password",
                                    hint: "",
                                    isPassword: true,
                                    controller: controller.reNewPasswordCon,
                                  ),
                                ],
                              ));
                        },
                        padding: EdgeInsets.all(12),
                        color: primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          'Ubah Password',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                      ),
                      Spacer(),
                      MaterialButton(
                        onPressed: () async {
                          await Get.defaultDialog<bool>(
                            title: "Konfirmasi",
                            middleText: 'Ingin keluar dari aplikasi?',
                            textCancel: "Batal",
                            textConfirm: "Keluar",
                            confirmTextColor: Colors.white,
                            onConfirm: () {

                              SystemNavigator.pop(animated: true);

                            },
                          );
                        },
                        padding: EdgeInsets.all(12),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          'Keluar',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ));
  }
}
