import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:point_of_sales/constant/constant.dart';
import 'package:point_of_sales/presentation/home/home_page.dart';
import 'package:point_of_sales/presentation/login/login_controller.dart';
import 'package:point_of_sales/presentation/main/main_container_page.dart';
import 'package:point_of_sales/widget/default_app_bar.dart';
import 'package:point_of_sales/widget/primary_button.dart';
import 'package:point_of_sales/widget/text_input_widget.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar("Login POS"),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 44,
              ),
              SvgPicture.asset(
                'assets/login_image.svg',
                width: MediaQuery.of(context).size.width / 2,
              ),
              SizedBox(
                height: 22,
              ),
              CustomTextInput(
                  label: "Email",
                  hint: "user@mail.com",
                  inputType: TextInputType.emailAddress,
                  controller: controller.emailCon),
              SizedBox(
                height: 16,
              ),
              CustomTextInput(
                  label: "Password",
                  hint: "your password",
                  isPassword: true,
                  controller: controller.passwordCon),
              SizedBox(
                height: 24,
              ),
              Obx(() => SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: PrimaryButton(
                      label: controller.isLoading.value ? "" : "Login",
                      onPressed: () async {
                        await controller
                            .login(controller.emailCon.text,
                                controller.passwordCon.text)
                            .then((value) {
                          if (value) {
                            Get.off(MainContainerPage());
                          } else {
                            Get.snackbar("Login Failed",
                                "Make sure password and email are correct",
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                margin: EdgeInsets.symmetric(vertical: 26, horizontal: 20),
                                snackPosition: SnackPosition.BOTTOM);
                          }
                        });
                      },
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
