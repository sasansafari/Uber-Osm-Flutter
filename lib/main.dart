import 'dart:io';
import 'package:UberApp/view/select_origin_to_destination.dart';
import 'package:flutter/material.dart';
 
import 'dimens.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    HttpOverrides.global = MyHttpOverrides();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
          fixedSize: const MaterialStatePropertyAll(Size(double.infinity, 58)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimens.medium))),
          elevation: MaterialStateProperty.all(0),
          backgroundColor: MaterialStateProperty.resolveWith(
            (states) {

              if (states.contains(MaterialState.pressed)) {
                return Colors.lightGreen;
              }
              
              return const Color.fromARGB(255, 2, 207, 36);

            },
          ),
        )),
      ),
      home:   UserSelectOrigin(),
    );
  }
}
