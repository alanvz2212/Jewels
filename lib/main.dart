import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:testapp/services/bindings.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: true,
      initialBinding: AppBinding(),
    );
  }

  void main() => runApp(MyApp());

  // void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // // await Stripe.instance.applySettings();
  // Stripe.publishableKey = stripePublishableKey;
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // runApp(MyApp());
  // }
}
