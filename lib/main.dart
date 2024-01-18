import 'package:eduventure/Controller/time_table_controller.dart';
import 'package:eduventure/screens/splash_screen.dart';
import 'package:eduventure/utils/colors.dart';
import 'package:eduventure/utils/custom_scrool_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: 'AIzaSyByG6m2bZAzFSUSXwj2AEsiRzuaqgwMMuQ',
      appId: '1:990438756842:web:78fe9e217d2e89b72ce293',
      messagingSenderId: '990438756842',
      projectId: 'edu-eduventure',
      storageBucket: 'edu-eduventure.appspot.com',
    ));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.put(TimeTableController());
    return MaterialApp(
      title: 'Eduventure',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: "SegSemiBold",
          useMaterial3: true,
          indicatorColor: colorPrimary,
          textSelectionTheme:  TextSelectionThemeData(
              cursorColor: colorPrimary,
              selectionColor: colorPrimary,
              selectionHandleColor: colorPrimary),
          appBarTheme:  AppBarTheme(
            surfaceTintColor: colorPrimary,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: colorPrimary,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.dark,
            ),
          )),
      scrollBehavior: MyCustomScrollBehavior(),
      home: SplashScreen(),
    );
  }
}
