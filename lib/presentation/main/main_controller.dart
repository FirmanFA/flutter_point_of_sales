import 'package:get/get.dart';

class MainController extends GetxController {

  var currentNavigation = 0.obs;

  setNav({required int nav}) {
    currentNavigation.value = nav;
  }
}
