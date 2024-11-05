import 'package:get/instance_manager.dart';
import 'package:video_ai/controllers/main_controller.dart';
import 'package:video_ai/controllers/user_controller.dart';

class StartupBindings with Bindings {
  @override
  void dependencies() {
    Get.put(MainController(), permanent: true);
    Get.put(UserController(), permanent: true);
  }
}
