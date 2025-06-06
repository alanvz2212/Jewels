import 'package:get/get.dart';
import 'package:testapp/controllers/address_controller.dart';
import 'package:testapp/controllers/auth_controller.dart';
import 'package:testapp/controllers/cart_controller.dart';
import 'package:testapp/controllers/offer_controller.dart';
import 'package:testapp/controllers/order_controller.dart';
import 'package:testapp/controllers/product_contorller.dart';
import 'package:testapp/controllers/profile_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // GetX Dependency Injection system.
    Get.put(ProductContorller(), permanent: true);
    Get.put(CartController(), permanent: true);
    Get.put(AuthController(), permanent: true);
    Get.put(AddressController(), permanent: true);
    Get.put(() => OfferController());
    //we are using a function or lambda to create the contorller called lazy loading
    Get.put(OrderController(), permanent: true);
    Get.lazyPut(() => ProfileController());
    // Saves memory and speed by creating the controller only when used.
    // Lazy loading: It doesn’t waste resources on screens/controllers you're not using right now.
  }
}
