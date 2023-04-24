import 'package:arp_scan/port.dart';
import 'package:arp_scanner/arp_scanner.dart';
import 'package:arp_scanner/device.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Device> devices = [];
  List<Device> filteredDevices = [];
  bool _isScanning = false;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    ArpScanner.onScanning.listen((Device device) {
      setState(() {
        devices.add(device);
        filteredDevices = devices;
      });
    });
    ArpScanner.onScanFinished.listen((List<Device> devices) {
      setState(() {
        this.devices = devices;
        filteredDevices = devices;
      });
    });
  }

  void _filterDevices(String value) {
    setState(() {
      filteredDevices = devices
          .where((device) =>
              device.hostname!.toLowerCase().contains(value.toLowerCase()) ||
              device.ip!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.bgClr,
      appBar: AppBar(
        backgroundColor: AppConstants.themeColor,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 20,
            width: 22,
            child: Image.asset(
              "assets/images/codesandbox.png",
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: const Text(
          'Network Scanner',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => PortScan(
                      title: "Port Scan",
                      selectedUrl: "https://dnschecker.org/port-scanner.php",
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.radar_outlined, color: Colors.white))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                // ...
                decoration: InputDecoration(
                  hintText: "Search by hostname or IP",
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  fillColor: Colors.white.withOpacity(0.1),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) => _filterDevices(value),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                _searchController.clear();
                devices.clear();
                setState(() {
                  filteredDevices = [];
                  _isScanning = true;
                });
                await ArpScanner.scan();
                setState(() {
                  _isScanning = false;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.themeColor,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              child: const Text(
                "Scan",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _isScanning
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: filteredDevices.isEmpty
                        ? const Center(
                            child: Text(
                              "No devices found",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemCount: filteredDevices.length,
                            separatorBuilder: (context, i) =>
                                const SizedBox(height: 5),
                            itemBuilder: (context, index) {
                              final device = filteredDevices[index];
                              return InkWell(
                                onDoubleTap: () {
                                  Clipboard.setData(
                                    ClipboardData(text: device.ip),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("IP Address Copied!"),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                },
                                child: Card(
                                  color: Colors.white.withOpacity(0.1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          device.vendor ?? 'Generic Device',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "Hostname: ${device.hostname ?? 'Unknown'}",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white70,
                                          ),
                                        ),
                                        Text(
                                          "IP: ${device.ip}",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white70,
                                          ),
                                        ),
                                        Text(
                                          "Last seen: ${device.time}",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
// ...
ArpScanner.cancel();
        },
        backgroundColor: AppConstants.themeColor,
        child: const Icon(Icons.cancel, color: Colors.white),
      ),
      bottomNavigationBar: Container(
        height: 30,
        alignment: Alignment.center,
        color: Colors.black.withOpacity(0.5),
        child: const Text(
          "Made by Bhargavi Gunreddy",
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class AppConstants {
  static const Color bgClr = Color.fromARGB(255, 56, 56, 56);
  static const Color themeColor = Color.fromARGB(255, 56, 56, 56);
}
