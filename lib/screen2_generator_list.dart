import 'package:flutter/material.dart';

import 'models/generator.dart';
import 'screen1_runtime_fuel.dart';
import 'screen3_add_generator.dart';
import 'screen4_generator_details.dart';
import 'screen5_app_info.dart';
import 'screen6_report.dart';
import 'services/storage_service.dart';

class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  final int _selectedIndex = 1;
  List<GeneratorModel> generators = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final loadedGenerators = await StorageService.loadGenerators();
    if (!mounted) return;
    setState(() {
      generators = loadedGenerators;
    });
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Screen1()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const Screen6()),
      );
    }
  }

  Future<void> _openAddGenerator() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const Screen3()),
    );
    await loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8FAF93),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Generator List",
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
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 20),
        itemCount: generators.length,
        itemBuilder: (context, index) {
          final item = generators[index];

          return Dismissible(
            key: ValueKey('${item.code}-${item.name}'),
            direction: DismissDirection.endToStart,
            background: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            confirmDismiss: (direction) async {
              return await showDialog<bool>(
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
                  ) ??
                  false;
            },
            onDismissed: (direction) async {
              generators.removeAt(index);
              await StorageService.saveGenerators(generators);
              setState(() {});
            },
            child: GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Screen4(
                      name: item.name,
                      code: item.code,
                      capacity: item.capacity,
                      usageRate: item.usageRate,
                    ),
                  ),
                );
                await loadData();
              },
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFA8D5A2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name, style: const TextStyle(fontSize: 16)),
                        Text(
                          item.code,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "${item.capacity.toStringAsFixed(0)}L",
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF7FA6C9),
        onPressed: _openAddGenerator,
        child: const Icon(Icons.add),
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
}
