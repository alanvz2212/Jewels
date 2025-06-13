import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/route_manager.dart';
import 'package:testapp/app/data/consts.dart';
import 'package:testapp/app/screens/login_screen.dart';
import 'package:testapp/app/screens/signup_screen.dart';
import 'package:testapp/app/screens/splash_screen.dart';
import 'package:testapp/app/services/bindings.dart';
import 'package:testapp/app/utilities/theme.dart';
import 'package:testapp/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Stripe.instance.applySettings();
  Stripe.publishableKey = stripePublishableKey;
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: AppBinding(),
      darkTheme: AppTheme.lightTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => SplashScreen()),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/signup', page: () => SignUpScreen()),
      ],
    );
  }
}
