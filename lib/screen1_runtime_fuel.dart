import 'package:flutter/material.dart';
import 'models/record.dart';
import 'models/generator.dart';
import 'screen2_generator_list.dart';
import 'screen5_app_info.dart';
import 'screen6_report.dart';
import 'services/storage_service.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  bool isRuntime = true;
  final int _selectedIndex = 0;
  List<GeneratorModel> generators = [];
  GeneratorModel? selectedGenerator;
  bool _isRestoringDraft = false;

  final TextEditingController hoursController = TextEditingController();
  final TextEditingController fuelController = TextEditingController();
  final TextEditingController fuelRateController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    hoursController.addListener(_saveEntryDraft);
    fuelController.addListener(_saveEntryDraft);
    fuelRateController.addListener(_saveEntryDraft);
    dateController.addListener(_saveEntryDraft);
    _loadGenerators();
  }

  Future<void> _loadGenerators() async {
    final loadedGenerators = await StorageService.loadGenerators();
    if (!mounted) return;

    setState(() {
      generators = loadedGenerators;
      selectedGenerator = null;
    });
    await _loadEntryDraft();
  }

  Future<void> _loadEntryDraft() async {
    final draft = await StorageService.loadEntryDraft();
    if (draft == null || !mounted) return;

    _isRestoringDraft = true;
    final generatorName = draft['generatorName']?.toString() ?? '';
    final generatorCode = draft['generatorCode']?.toString() ?? '';
    GeneratorModel? restoredGenerator;
    for (final generator in generators) {
      if (generator.name == generatorName && generator.code == generatorCode) {
        restoredGenerator = generator;
        break;
      }
    }

    setState(() {
      isRuntime = draft['isRuntime'] as bool? ?? true;
      selectedGenerator = restoredGenerator;
      hoursController.text = draft['hours']?.toString() ?? '';
      fuelController.text = draft['fuel']?.toString() ?? '';
      fuelRateController.text = draft['fuelRate']?.toString() ?? '';
      dateController.text = draft['date']?.toString() ?? '';
    });
    _isRestoringDraft = false;
  }

  Future<void> _saveEntryDraft() async {
    if (_isRestoringDraft) return;

    try {
      await StorageService.saveEntryDraft({
        'isRuntime': isRuntime,
        'generatorName': selectedGenerator?.name ?? '',
        'generatorCode': selectedGenerator?.code ?? '',
        'hours': hoursController.text,
        'fuel': fuelController.text,
        'fuelRate': fuelRateController.text,
        'date': dateController.text,
      });
    } catch (e) {
      // Draft save failures should not block the user from entering records.
    }
  }

  @override
  void dispose() {
    hoursController.removeListener(_saveEntryDraft);
    fuelController.removeListener(_saveEntryDraft);
    fuelRateController.removeListener(_saveEntryDraft);
    dateController.removeListener(_saveEntryDraft);
    hoursController.dispose();
    fuelController.dispose();
    fuelRateController.dispose();
    dateController.dispose();
    super.dispose();
  }

  ///////////////////////////////////////////////////////////
  /// 🔹 BOTTOM NAVIGATION
  ///////////////////////////////////////////////////////////
  void _onItemTapped(int index) {
    if (index == 0) return; // Stay on Screen1

    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Screen2()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Screen6()),
      );
    }
  }

  ///////////////////////////////////////////////////////////
  /// 🔹 CONFIRMATION POPUP
  ///////////////////////////////////////////////////////////
  void _showConfirmDialog() {
    if (selectedGenerator == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a generator")),
      );
      return;
    }

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
                const Text("Are you sure", style: TextStyle(fontSize: 16)),

                const SizedBox(height: 20),

                ///////////////////////////////////////////////////
                /// BUTTONS
                ///////////////////////////////////////////////////
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ///////////////////////////////////////////////////
                    /// CANCEL
                    ///////////////////////////////////////////////////
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "cancel",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),

                    ///////////////////////////////////////////////////
                    /// ✅ CONFIRM (UPDATED)
                    ///////////////////////////////////////////////////
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                      ),
                      onPressed: () async {
                        ///////////////////////////////////////////////////
                        /// 🔹 LOAD EXISTING RECORDS
                        ///////////////////////////////////////////////////
                        List<Record> records =
                            await StorageService.loadRecords();

                        final generator = selectedGenerator!;
                        final enteredDate = dateController.text.trim();

                        ///////////////////////////////////////////////////
                        /// 🔹 CALCULATE NEW VALUES
                        ///////////////////////////////////////////////////
                        double hours =
                            double.tryParse(hoursController.text) ?? 0;
                        double fuelAdded =
                            double.tryParse(fuelController.text) ?? 0;
                        double fuelRate =
                            double.tryParse(fuelRateController.text) ?? 0;
                        double usageRate = generator.usageRate;
                        double fuelUsed = isRuntime ? hours * usageRate : 0;
                        double fuelCost = fuelAdded * fuelRate;

                        ///////////////////////////////////////////////////
                        /// 🔹 CHECK FOR EXISTING RECORD ON SAME DAY
                        ///////////////////////////////////////////////////
                        int existingIndex = records.indexWhere((record) =>
                            record.generator == generator.name &&
                            record.date == enteredDate);

                        if (existingIndex != -1) {
                          ///////////////////////////////////////////////////
                          /// 🔹 MERGE WITH EXISTING RECORD
                          ///////////////////////////////////////////////////
                          records[existingIndex].hours += hours;
                          records[existingIndex].fuelAdded += fuelAdded;
                          records[existingIndex].fuelUsed += fuelUsed;
                          records[existingIndex].fuelCost += fuelCost;
                        } else {
                          ///////////////////////////////////////////////////
                          /// 🔹 CREATE NEW RECORD
                          ///////////////////////////////////////////////////
                          records.add(
                            Record(
                              generator: generator.name,
                              hours: hours,
                              fuelAdded: fuelAdded,
                              fuelUsed: fuelUsed,
                              fuelCost: fuelCost,
                              date: enteredDate,
                            ),
                          );
                        }

                        await StorageService.saveRecords(records);
                        if (!context.mounted) return;

                        ///////////////////////////////////////////////////
                        /// 🔹 CLOSE DIALOG AND RESET FORM
                        ///////////////////////////////////////////////////
                        Navigator.pop(context);
                        _isRestoringDraft = true;
                        hoursController.clear();
                        fuelController.clear();
                        fuelRateController.clear();
                        dateController.clear();
                        await StorageService.clearEntryDraft();
                        _isRestoringDraft = false;
                        if (!context.mounted) return;
                        setState(() {
                          selectedGenerator = null;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Record saved")),
                        );

                        // OR (if you want go to Screen2)
                        /*
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const Screen2()),
                      );
                      */
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

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 10),
    );

    if (pickedDate == null) return;

    dateController.text =
        "${_twoDigits(pickedDate.day)}/${_twoDigits(pickedDate.month)}/${pickedDate.year}";
  }

  String _twoDigits(int value) => value.toString().padLeft(2, "0");

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
        centerTitle: true,
        title: const Text(
          "Fuel Tracker",
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
                    onTap: () {
                      setState(() => isRuntime = true);
                      _saveEntryDraft();
                    },
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
                    onTap: () {
                      setState(() => isRuntime = false);
                      _saveEntryDraft();
                    },
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
                  _generatorDropdown(),
                  const SizedBox(height: 16),

                  if (isRuntime) ...[
                    _input(
                      "Enter hours",
                      controller: hoursController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    _dateInput(),
                  ] else ...[
                    _input(
                      "Added Fuel Amount (L)",
                      controller: fuelController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    _input("Fuel Type"),
                    const SizedBox(height: 16),
                    _dateInput(),
                    const SizedBox(height: 16),
                    _input(
                      "Fuel Rate (Rs)",
                      controller: fuelRateController,
                      keyboardType: TextInputType.number,
                    ),
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
                        padding: const EdgeInsets.symmetric(vertical: 14),
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
            icon: Icon(Icons.local_gas_station),
            label: "",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.edit_document), label: ""),
        ],
      ),
    );
  }

  ///////////////////////////////////////////////////////////
  /// INPUT FIELD
  ///////////////////////////////////////////////////////////
  Widget _generatorDropdown() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFD0D0D0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<GeneratorModel>(
          value: selectedGenerator,
          hint: const Text(
            "Select Generator",
            style: TextStyle(color: Colors.black38),
          ),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          items: generators.map((generator) {
            return DropdownMenuItem<GeneratorModel>(
              value: generator,
              child: Text(
                generator.code.isEmpty
                    ? generator.name
                    : "${generator.name} (${generator.code})",
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedGenerator = value;
            });
            _saveEntryDraft();
          },
        ),
      ),
    );
  }

  Widget _input(
    String hint, {
    bool icon = false,
    TextEditingController? controller,
    TextInputType? keyboardType,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFD0D0D0)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black38),
          suffixIcon: icon
              ? const Icon(Icons.calendar_today, size: 18, color: Colors.grey)
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _dateInput() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFD0D0D0)),
      ),
      child: TextField(
        controller: dateController,
        keyboardType: TextInputType.datetime,
        onTap: _selectDate,
        decoration: InputDecoration(
          hintText: "Select Date",
          hintStyle: const TextStyle(color: Colors.black38),
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.calendar_today,
              size: 18,
              color: Colors.grey,
            ),
            onPressed: _selectDate,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
