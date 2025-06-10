import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var isLoading = false.obs;
  var verificationId = ''.obs;
  Rx<User?> user = Rx<User?>(null);
  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
  }
}
