import 'package:dor_companion/mobile/profile/controller/profile_controller.dart';
import 'package:get/get.dart';

class LogInScreenBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}