import 'package:flutter/material.dart';
import 'screen2_generator_list.dart';
import 'screen3_add_generator.dart';
import 'screen5_app_info.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  bool isRuntime = true;
  int _selectedIndex = 0;

  ///////////////////////////////////////////////////////////
  /// 🔹 BOTTOM NAVIGATION
  ///////////////////////////////////////////////////////////
  void _onItemTapped(int index) {
    if (index == 0) return;

    if (index == 1) {
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

  ///////////////////////////////////////////////////////////
  /// 🔹 CONFIRMATION POPUP
  ///////////////////////////////////////////////////////////
  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ///////////////////////////////////////////////////
                /// TEXT
                ///////////////////////////////////////////////////
                const Text(
                  "Are you sure",
                  style: TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 20),

                ///////////////////////////////////////////////////
                /// BUTTONS
                ///////////////////////////////////////////////////
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "cancel",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                      ),
                      onPressed: () {
                        Navigator.pop(context);

                         // Navigate after confirm
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const Screen2()),
                        );
                      },
                      child: const Text("confirm"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ///////////////////////////////////////////////////////////
  /// 🔹 BUILD UI
  ///////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),

      ///////////////////////////////////////////////////////////
      /// APP BAR
      ///////////////////////////////////////////////////////////
      appBar: AppBar(
        backgroundColor: const Color(0xFF8FAF93),
        elevation: 0,
        title: const Text("Fuel Tracker", style: TextStyle(color: Colors.white),),
        leading: const Icon(Icons.menu, color: Colors.white,),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Screen5()),
              );
            },
          )
        ],
      ),

      ///////////////////////////////////////////////////////////
      /// BODY
      ///////////////////////////////////////////////////////////
      body: Column(
        children: [
          ///////////////////////////////////////////////////////
          /// TAB SWITCH (FIGMA STYLE)
          ///////////////////////////////////////////////////////
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFFA8D5A2),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isRuntime = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isRuntime ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Center(child: Text("Runtime")),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isRuntime = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: !isRuntime ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Center(child: Text("Fuel")),
                    ),
                  ),
                ),
              ],
            ),
          ),

          ///////////////////////////////////////////////////////
          /// FORM
          ///////////////////////////////////////////////////////
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _input("Select Generator"),
                  const SizedBox(height: 16),

                  if (isRuntime) ...[
                    _input("Enter hours"),
                    const SizedBox(height: 16),
                    _input("Select Date", icon: true),
                  ] else ...[
                    _input("Added Fuel Amount"),
                    const SizedBox(height: 16),
                    _input("Fuel Type"),
                    const SizedBox(height: 16),
                    _input("Select Date", icon: true),
                    const SizedBox(height: 16),
                    _input("Fuel Rate"),
                  ],

                  const SizedBox(height: 24),

                  ///////////////////////////////////////////////////
                  /// SAVE BUTTON → SHOW POPUP
                  ///////////////////////////////////////////////////
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7FA6C9),
                        padding:
                        const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onPressed: _showConfirmDialog,
                      child: const Text("Save"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      ///////////////////////////////////////////////////////////
      /// BOTTOM NAVIGATION
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
  /// INPUT FIELD
  ///////////////////////////////////////////////////////////
  Widget _input(String hint, {bool icon = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFD0D0D0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(hint, style: const TextStyle(color: Colors.black38)),
          if (icon)
            const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
        ],
      ),
    );
  }
}