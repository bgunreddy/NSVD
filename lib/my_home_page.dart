import 'package:arp_scan/constants.dart';
import 'package:arp_scanner/arp_scanner.dart';
import 'package:arp_scanner/device.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({
    super.key
  });


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // String _platformVersion = 'Unknown';
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
    return Scaffold(
     
      backgroundColor: AppConstants.bgClr,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: InkWell(
          onTap: () async {
            //scan sub net devices
            devices.clear();
            await ArpScanner.scan();
            // debugPrint(_platformVersion);
          },
          child: Container(
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 18).copyWith(bottom: 10),
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
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
              height: 20,
              width: 22,
              child: Image.asset(
                "assets/images/codesandbox.png",
                fit: BoxFit.contain,
              )),
        ),
        title: const Text('NSVD'),
      ),
      floatingActionButton: FloatingActionButton(onPressed:() async {
        // devices.clear();
              await ArpScanner.cancel();
            }, child: const  Icon(Icons.cancel),
            
          ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: devices.length,
          separatorBuilder: (_,i)=> const SizedBox(height: 5),
          itemBuilder: (context, index) {
            final device = devices[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  width: MediaQuery.of(context).size.width*0.8,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text("Vendor: ${device.vendor ?? 'Generic Device'}"),
                          Text("Hostname: ${device.hostname ?? 'Generic Device'}"),
                          Text("Ip: ${device.ip}"),
                          Text("Time: ${device.time}"),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
