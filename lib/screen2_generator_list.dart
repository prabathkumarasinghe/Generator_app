import 'package:flutter/material.dart';
import 'screen1_runtime_fuel.dart';
import 'screen3_add_generator.dart';
import 'screen4_generator_details.dart';

class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  int _selectedIndex = 1;

  ///////////////////////////////////////////////////////////
  /// 🔹 GENERATOR DATA (DYNAMIC LIST)
  ///////////////////////////////////////////////////////////
  List<Map<String, String>> generators = [
    {"name": "Gen A - CAT2", "fuel": "120L"},
    {"name": "Gen B - CAT3", "fuel": "120L"},
    {"name": "Gen C - CAT4", "fuel": "120L"},
    {"name": "Gen D - CAT5", "fuel": "120L"},
  ];

  ///////////////////////////////////////////////////////////
  /// 🔹 BOTTOM NAVIGATION
  ///////////////////////////////////////////////////////////
  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Screen1()),
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
        title: const Text("Generator List", style: TextStyle(color: Colors.white),),
        leading: const Icon(Icons.menu, color: Colors.white,),
        actions: const [
          Icon(Icons.info_outline, color: Colors.white,),
          SizedBox(width: 10),
        ],
      ),

      ///////////////////////////////////////////////////////////
      /// 🔹 BODY (LIST WITH SWIPE DELETE)
      ///////////////////////////////////////////////////////////
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 20),
        itemCount: generators.length,
        itemBuilder: (context, index) {
          final item = generators[index];

          return Dismissible(
            key: Key(item["name"]!),

            /////////////////////////////////////////////////////
            /// SWIPE LEFT BACKGROUND
            /////////////////////////////////////////////////////
            direction: DismissDirection.endToStart,
            background: Container(
              margin:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.delete, color: Colors.white),
            ),

            /////////////////////////////////////////////////////
            /// CONFIRM DELETE
            /////////////////////////////////////////////////////
            confirmDismiss: (direction) async {
              return await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Are you sure?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Delete"),
                    ),
                  ],
                ),
              );
            },

            /////////////////////////////////////////////////////
            /// REMOVE ITEM
            /////////////////////////////////////////////////////
            onDismissed: (direction) {
              setState(() {
                generators.removeAt(index);
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Generator deleted")),
              );
            },

            /////////////////////////////////////////////////////
            /// GREEN LIST ITEM (FIGMA STYLE)
            /////////////////////////////////////////////////////
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Screen4(
                      name: item["name"]!,
                      code: item["name"]!,
                      fuel: item["fuel"]!,
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 18),
                decoration: BoxDecoration(
                  color: const Color(0xFFA8D5A2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item["name"]!,
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      item["fuel"]!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),

      ///////////////////////////////////////////////////////////
      /// 🔹 FLOATING ADD BUTTON
      ///////////////////////////////////////////////////////////
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF7FA6C9),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const Screen3()),
          );
        },
        child: const Icon(Icons.add),
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
}