import 'package:get/get.dart';
import 'controller/network_controller.dart';

class DependencyInjection {
  
  static void init() {
    Get.put<NetworkController>(NetworkController(),permanent:true); // Controller นี้จะไม่ถูกลบออกจากหน่วยความจำ (App จะถือครองตลอดอายุการใช้งาน)
  }
}