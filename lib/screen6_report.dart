import 'package:flutter/material.dart';

import 'models/record.dart';
import 'screen1_runtime_fuel.dart';
import 'screen2_generator_list.dart';
import 'screen5_app_info.dart';
import 'services/storage_service.dart';

class Screen6 extends StatefulWidget {
  const Screen6({super.key});

  @override
  State<Screen6> createState() => _Screen6State();
}

class _Screen6State extends State<Screen6> {
  final int _selectedIndex = 2;
  List<Record> records = [];

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    final loadedRecords = await StorageService.loadRecords();
    if (!mounted) return;

    setState(() {
      records = loadedRecords;
    });
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Screen1()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Screen2()),
      );
    } else if (index == 2) {
      return; // Stay on Screen6 (Report page)
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalHours = records.fold<double>(0, (sum, r) => sum + r.hours);
    final totalFuelAdded = records.fold<double>(
      0,
      (sum, r) => sum + r.fuelAdded,
    );
    final totalFuelUsed = records.fold<double>(
      0,
      (sum, r) => sum + r.fuelUsed,
    );
    final totalFuelCost = records.fold<double>(
      0,
      (sum, r) => sum + r.fuelCost,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8FAF93),
        elevation: 0,
        centerTitle: true,
        title: const Text("Report", style: TextStyle(color: Colors.white)),
        leading: const Icon(Icons.menu, color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Screen5()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: const Color(0xFFA8D5A2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _summary("Hours", totalHours.toStringAsFixed(1)),
                _summary("Added", "${totalFuelAdded.toStringAsFixed(1)}L"),
                _summary("Used", "${totalFuelUsed.toStringAsFixed(1)}L"),
                _summary("Cost", "Rs ${totalFuelCost.toStringAsFixed(2)}"),
              ],
            ),
          ),
          Expanded(
            child: records.isEmpty
                ? const Center(child: Text("No records saved"))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final record = records[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFD0D0D0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              record.generator,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text("Date: ${record.date}"),
                            Text("Hours: ${record.hours.toStringAsFixed(1)}"),
                            Text(
                              "Fuel added: ${record.fuelAdded.toStringAsFixed(1)}L",
                            ),
                            Text(
                              "Fuel used: ${record.fuelUsed.toStringAsFixed(1)}L",
                            ),
                            Text(
                              "Fuel cost: Rs ${record.fuelCost.toStringAsFixed(2)}",
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFF2F2F2),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_gas_station),
            label: "",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.edit_document), label: ""),
        ],
      ),
    );
  }

  Widget _summary(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.black54)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
