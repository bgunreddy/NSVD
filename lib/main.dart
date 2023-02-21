import 'package:arp_scanner/device.dart';
import 'package:flutter/material.dart';

import 'package:arp_scanner/arp_scanner.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'my_homepage.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
  // FlutterNativeSplash.remove();
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Device> devices = [];

  @override
  void initState() {
    super.initState();
    ArpScanner.onScanning.listen((Device device) {
      setState(() {
        devices.add(device);
      });
    });
    ArpScanner.onScanFinished.listen((List<Device> devices) {
      setState(() {
        this.devices = devices;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Lato"),
      home: HomePage(devices: devices),
    );
  }
}
