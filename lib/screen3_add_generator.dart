import 'package:flutter/material.dart';
import 'screen1_runtime_fuel.dart';
import 'screen2_generator_list.dart';
import '../models/generator.dart';
import '../services/storage_service.dart';

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

  int _selectedIndex = 2;

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
        title: const Text("Add Generator", style: TextStyle(color: Colors.white),),
        leading: const Icon(Icons.menu, color: Colors.white,),
        actions: const [
          Icon(Icons.info_outline, color: Colors.white,),
          SizedBox(width: 10),
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
            _label("Fuel Tank Capacity"),
            TextField(
              controller: capacityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter capacity",
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
            _label("Fuel Usage Rate"),
            TextField(
              controller: rateController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter rate",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),




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
                onPressed: () {
                  Navigator.pop(context);
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
              icon: Icon(Icons.local_gas_station), label: ""),
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
      child: Text(
        text,
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }

  ///////////////////////////////////////////////////////////
  /// 🔹 INPUT FIELD
  ///////////////////////////////////////////////////////////
  Widget _input(String hint) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFD0D0D0)),
      ),
      child: Text(
        hint,
        style: const TextStyle(color: Colors.black38),
      ),
    );
  }
}