import 'package:flutter/material.dart';
import 'models/generator.dart';
import 'screen1_runtime_fuel.dart';
import 'screen2_generator_list.dart';
import 'screen5_app_info.dart';
import 'screen6_report.dart';
import 'services/storage_service.dart';

class Screen3 extends StatefulWidget {
  const Screen3({super.key});

  @override
  State<Screen3> createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController rateController = TextEditingController();

  final int _selectedIndex = 2;

  @override
  void dispose() {
    nameController.dispose();
    codeController.dispose();
    capacityController.dispose();
    rateController.dispose();
    super.dispose();
  }

  ///////////////////////////////////////////////////////////
  /// 🔹 BOTTOM NAVIGATION
  ///////////////////////////////////////////////////////////
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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const Screen6()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),

      ///////////////////////////////////////////////////////////
      /// 🔹 APP BAR
      ///////////////////////////////////////////////////////////
      appBar: AppBar(
        backgroundColor: const Color(0xFF8FAF93),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Add Generator",
          style: TextStyle(color: Colors.white),
        ),
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

      ///////////////////////////////////////////////////////////
      /// 🔹 BODY
      ///////////////////////////////////////////////////////////
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /////////////////////////////////////////////////////
            /// Generator Name
            /////////////////////////////////////////////////////
            _label("Generator Name"),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Enter generator name",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /////////////////////////////////////////////////////
            /// Generator Code
            /////////////////////////////////////////////////////
            _label("Generator Code"),
            TextField(
              controller: codeController,
              decoration: InputDecoration(
                hintText: "Enter generator code",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /////////////////////////////////////////////////////
            /// Capacity
            /////////////////////////////////////////////////////
            _label("Fuel Tank Capacity (L)"),
            TextField(
              controller: capacityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter capacity (L)",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /////////////////////////////////////////////////////
            /// Usage Rate
            /////////////////////////////////////////////////////
            _label("Fuel Usage Rate (L/hr)"),
            TextField(
              controller: rateController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter rate (L/hr)",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),

            const SizedBox(height: 24),

            /////////////////////////////////////////////////////
            /// 🔹 SAVE BUTTON
            /////////////////////////////////////////////////////
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7FA6C9),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () async {
                  try {
                    final generators = await StorageService.loadGenerators();
                    generators.add(
                      GeneratorModel(
                        name: nameController.text.trim(),
                        code: codeController.text.trim(),
                        capacity: double.tryParse(capacityController.text) ?? 0,
                        usageRate: double.tryParse(rateController.text) ?? 0,
                      ),
                    );
                    await StorageService.saveGenerators(generators);
                    if (!context.mounted) return;
                    Navigator.pop(context);
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                },
                child: const Text("Save"),
              ),
            ),
          ],
        ),
      ),

      ///////////////////////////////////////////////////////////
      /// 🔹 BOTTOM NAVIGATION
      ///////////////////////////////////////////////////////////
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
            //icon: Icon(Icons.electrical_services), label: ""),
            icon: Icon(Icons.local_gas_station),
            label: "",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.edit_document), label: ""),
        ],
      ),
    );
  }

  ///////////////////////////////////////////////////////////
  /// 🔹 LABEL TEXT
  ///////////////////////////////////////////////////////////
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 6),
      child: Text(text, style: const TextStyle(color: Colors.grey)),
    );
  }

  ///////////////////////////////////////////////////////////
  /// 🔹 INPUT FIELD
  ///////////////////////////////////////////////////////////
}
