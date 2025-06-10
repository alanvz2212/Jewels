import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/route_manager.dart';
import 'package:testapp/app/screens/login_screen.dart';
import 'package:testapp/app/screens/splash_screen.dart';
import 'package:testapp/app/services/bindings.dart';
import 'package:testapp/app/utilities/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: true,
      initialBinding: AppBinding(),
      darkTheme: AppTheme.lightTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => SplashScreen()),
        GetPage(name: '/login', page: () => LoginScreen()),
      ],
    );
  }


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
