import 'package:flutter/material.dart';
import 'screen1_runtime_fuel.dart';
import 'screen2_generator_list.dart';
import 'screen3_add_generator.dart';

class Screen5 extends StatefulWidget {
  const Screen5({super.key});

  @override
  State<Screen5> createState() => _Screen5State();
}

class _Screen5State extends State<Screen5> {
  final int _selectedIndex = 0;

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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Screen3()),
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
        title: const Text("About App", style: TextStyle(color: Colors.white)),
        leading: const Icon(Icons.menu, color: Colors.white),
        actions: const [
          Icon(Icons.info_outline, color: Colors.white),
          SizedBox(width: 10),
        ],
      ),

      ///////////////////////////////////////////////////////////
      /// 🔹 BODY
      ///////////////////////////////////////////////////////////
      body: Column(
        children: [
          ///////////////////////////////////////////////////////
          /// 🔹 BACK BUTTON
          ///////////////////////////////////////////////////////
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          ///////////////////////////////////////////////////////
          /// 🔹 GREEN INFO CARD
          ///////////////////////////////////////////////////////
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(vertical: 40),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF8FAF93),
              borderRadius: BorderRadius.circular(6),
            ),

            /////////////////////////////////////////////////////
            /// 🔹 CONTENT
            /////////////////////////////////////////////////////
            child: Column(
              children: const [
                Text(
                  "Generator Fuel App",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(height: 30),

                Text("Version: 1.0.0", style: TextStyle(color: Colors.white)),
                SizedBox(height: 20),

                Text(
                  "Developed by: Prabath",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20),

                Text("Flutter v3.1.4", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
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
}
