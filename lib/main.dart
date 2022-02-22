import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:livu/SizedConfig.dart';
import 'package:livu/View/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp();
  runApp(EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('ar', 'EG')],
      path: 'lang', // <-- change the path of the translation files
      fallbackLocale: Locale('en', 'US'),
      child: MyApp())); // Wrap your app
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
        return GetMaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: [Locale('en', 'US'), Locale('ar', 'AE')],
          locale: Locale(context.locale.languageCode),

          theme: ThemeData(
            primarySwatch: Colors.grey,
            primaryColor: Colors.black,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          // locale: DevicePreview.locale(context), // Add the locale here
          // builder: DevicePreview.appBuilder, // Add the builder here
          debugShowCheckedModeBanner: false,

          home: SplashScreen(),
        );
      });
    });
  }
}
