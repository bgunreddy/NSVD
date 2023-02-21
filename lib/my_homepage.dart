import 'package:arp_scanner/arp_scanner.dart';
import 'package:arp_scanner/device.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newapp1/constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.devices,
  });

  final List<Device> devices;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //     child: const Icon(Icons.scanner_sharp),
      //     onPressed: () async {
      //       //scan sub net devices
      //       devices.clear();
      //       await ArpScanner.scan();
      //     }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: InkWell(
          onTap: () async {
            //scan sub net devices
            devices.clear();
            await ArpScanner.scan();
          },
          child: Container(
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color.fromARGB(212, 33, 149, 243),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Text(
              "Scan",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: AppConstants.themeColor,
        // leading: SvgPicture.asset('assets/images/codesandbox.svg'),
        leading: SizedBox(
            height: 32,
            width: 34,
            child: Image.asset(
              "assets/images/codesandbox.png",
              fit: BoxFit.contain,
            )),
        actions: <Widget>[
          // action button
          IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () async {
              await ArpScanner.cancel();
            },
          ),
        ],
        title: const Text('NSVD'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: devices.length,
          itemBuilder: (context, index) {
            final device = devices[index];
            return Card(
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hostname: ${device.hostname ?? 'Unknown'}"),
                    Text("Ip: ${device.ip}"),
                    Text("Mac: ${device.mac ?? 'Unknown'}"),
                    Text("Time: ${device.time}"),
                    Text("Vendor: ${device.vendor ?? 'Unknown'}"),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
