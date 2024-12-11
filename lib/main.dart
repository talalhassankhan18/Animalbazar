import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_store/Screens/LoginPage.dart';
import 'package:pet_store/mainScreen.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:cloudinary_flutter/cloudinary_context.dart';

import 'Theme/Theme.dart';  
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  User? currentUser = FirebaseAuth.instance.currentUser;

  CloudinaryContext.cloudinary =
      Cloudinary.fromCloudName(cloudName: 'dwxd6ynem', apiKey: "mKbunEDHbF6Hoo1tiuej3aI756o");

  runApp(MyApp(currentUser: currentUser));
}

class MyApp extends StatelessWidget {
  final User? currentUser;

  MyApp({this.currentUser});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Pet Store',
          theme: AppTheme.theme,            home: currentUser == null ? SignningWidget() : MainScreen(),
        );
      },
    );
  }
}
