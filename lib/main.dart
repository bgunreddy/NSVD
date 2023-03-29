import 'package:arp_scan/my_home_page.dart';
import 'package:arp_scanner/device.dart';
import 'package:flutter/material.dart';

import 'package:arp_scanner/arp_scanner.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';


Future main()async {
   WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // ignore: deprecated_member_use
  FlutterNativeSplash.removeAfter(intialization);
  await intialization(null);
  runApp(const MyApp());
  // FlutterNativeSplash.remove();
}

Future intialization(BuildContext? context) async{
  await Future.delayed(const Duration(seconds: 3));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Lato"),
      home:const HomePage(),
    );
  }
}
