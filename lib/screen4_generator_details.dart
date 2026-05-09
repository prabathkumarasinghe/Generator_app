import 'package:flutter/material.dart';
import 'screen1_runtime_fuel.dart';
import 'screen2_generator_list.dart';
import 'screen5_app_info.dart';
import 'screen6_report.dart';
import 'models/generator.dart';
import 'models/record.dart';
import 'services/storage_service.dart';

class Screen4 extends StatefulWidget {
  final String name;
  final String code;
  final double capacity;
  final double usageRate;

  const Screen4({
    super.key,
    required this.name,
    required this.code,
    required this.capacity,
    required this.usageRate,
  });

  @override
  State<Screen4> createState() => _Screen4State();
}

class _Screen4State extends State<Screen4> {
  final int _selectedIndex = 1;
  final TextEditingController dateController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController usageRateController = TextEditingController();

  double remainingFuel = 0.0;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.name;
    codeController.text = widget.code;
    capacityController.text = widget.capacity.toStringAsFixed(0);
    usageRateController.text = widget.usageRate.toStringAsFixed(0);
    _calculateRemainingFuel();
  }

  Future<void> _calculateRemainingFuel() async {
    List<Record> allRecords = await StorageService.loadRecords();
    List<Record> generatorRecords = allRecords
        .where((r) => r.generator == widget.name)
        .toList();

    double totalFuelUsed = generatorRecords.fold(
      0.0,
      (sum, r) => sum + r.fuelUsed,
    );
    double totalFuelAdded = generatorRecords.fold(
      0.0,
      (sum, r) => sum + r.fuelAdded,
    );
    remainingFuel = widget.capacity - totalFuelUsed + totalFuelAdded;

    setState(() {});
  }

  @override
  void dispose() {
    dateController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    nameController.dispose();
    codeController.dispose();
    capacityController.dispose();
    usageRateController.dispose();
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
        title: Text(widget.name, style: const TextStyle(color: Colors.white)),
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
            /// 🔹 BACK BUTTON
            /////////////////////////////////////////////////////
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),

            /////////////////////////////////////////////////////
            /// 🔹 INPUT STYLE FIELDS
            /////////////////////////////////////////////////////
            _label("Generator Name"),
            _input(widget.name),

            _label("Generator Code"),
            _input(widget.code),

            _label("Fuel Tank Capacity (L)"),
            _input("${widget.capacity.toStringAsFixed(0)}L"),

            _label("Fuel Usage Rate (L/hr)"),
            _input("${widget.usageRate.toStringAsFixed(0)}L/hr"),

            _label("Fuel Remaining (L)"),
            _input("${remainingFuel.toStringAsFixed(1)}L"),

            const SizedBox(height: 30),

            /////////////////////////////////////////////////////
            /// 🔹 BUTTONS
            /////////////////////////////////////////////////////
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _button("Update", onPressed: _showUpdateDialog),
                _button(
                  "Report",
                  onPressed: () {
                    _showReportDialog(context);
                  },
                ),
              ],
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
            //icon: Icon(Icons.electrical_services),
            //label: "",
            icon: Icon(Icons.local_gas_station),
            label: "",
          ),

          BottomNavigationBarItem(icon: Icon(Icons.edit_document), label: ""),
        ],
      ),
    );
  }

  ///////////////////////////////////////////////////////////
  /// 🔹 LABEL
  ///////////////////////////////////////////////////////////
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 6),
      child: Text(text, style: const TextStyle(color: Colors.grey)),
    );
  }

  ///////////////////////////////////////////////////////////
  /// 🔹 INPUT BOX
  ///////////////////////////////////////////////////////////
  Widget _input(String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFD0D0D0)),
      ),
      child: Text(value, style: const TextStyle(color: Colors.black54)),
    );
  }

  ///////////////////////////////////////////////////////////
  /// 🔹 BUTTON
  ///////////////////////////////////////////////////////////
  Widget _button(String text, {VoidCallback? onPressed}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF7FA6C9),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      onPressed: onPressed ?? () {},
      child: Text(text),
    );
  }

  ///////////////////////////////////////////////////////////
  /// 🔹 REPORT POPUP
  ///////////////////////////////////////////////////////////
  void _showUpdateDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Update Generator"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _dialogInput("Generator Name", nameController),
                const SizedBox(height: 12),
                _dialogInput("Generator Code", codeController),
                const SizedBox(height: 12),
                _dialogInput(
                  "Fuel Tank Capacity (L)",
                  capacityController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                _dialogInput(
                  "Fuel Usage Rate (L/hr)",
                  usageRateController,
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final generators = await StorageService.loadGenerators();
                  final index = generators.indexWhere(
                    (generator) =>
                        generator.name == widget.name &&
                        generator.code == widget.code,
                  );

                  if (index == -1) {
                    throw Exception("Generator not found");
                  }

                  final updatedName = nameController.text.trim();
                  final updatedGenerator = GeneratorModel(
                    name: updatedName,
                    code: codeController.text.trim(),
                    capacity: double.tryParse(capacityController.text) ?? 0,
                    usageRate: double.tryParse(usageRateController.text) ?? 0,
                  );

                  generators[index] = updatedGenerator;
                  await StorageService.saveGenerators(generators);

                  if (updatedName != widget.name) {
                    final records = await StorageService.loadRecords();
                    final updatedRecords = records.map((record) {
                      if (record.generator == widget.name) {
                        return Record(
                          generator: updatedName,
                          hours: record.hours,
                          fuelAdded: record.fuelAdded,
                          fuelUsed: record.fuelUsed,
                          fuelCost: record.fuelCost,
                          date: record.date,
                        );
                      }
                      return record;
                    }).toList();
                    await StorageService.saveRecords(updatedRecords);
                  }

                  if (!mounted) return;
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(true);
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  Widget _dialogInput(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  void _showReportDialog(BuildContext context) async {
    List<Record> allRecords = await StorageService.loadRecords();
    List<Record> generatorRecords = allRecords
        .where((r) => r.generator == widget.name)
        .toList();

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            List<Record> filtered = generatorRecords;
            if (startDateController.text.isNotEmpty &&
                endDateController.text.isNotEmpty) {
              filtered = generatorRecords.where((r) {
                return r.date.compareTo(startDateController.text) >= 0 &&
                    r.date.compareTo(endDateController.text) <= 0;
              }).toList();
            }

            // Calculate totals
            double totalFuelUsed = filtered.fold(
              0.0,
              (sum, r) => sum + r.fuelUsed,
            );
            double totalFuelAdded = filtered.fold(
              0.0,
              (sum, r) => sum + r.fuelAdded,
            );
            double remainingFuel =
                widget.capacity - totalFuelUsed + totalFuelAdded;

            // Forecast
            int totalDays = filtered.isNotEmpty
                ? filtered.length
                : 1; // rough estimate
            double avgUsage = totalFuelUsed / totalDays;
            double forecast7Days = avgUsage * 7;
            double forecast30Days = avgUsage * 30;

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              insetPadding: const EdgeInsets.all(12),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ///////////////////////////////////////////////////
                            /// TITLE
                            ///////////////////////////////////////////////////
                            const Text(
                              "Generator Report",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 16),

                            ///////////////////////////////////////////////////
                            /// DATE RANGE PICKER
                            ///////////////////////////////////////////////////
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF2F2F2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Select Date Period",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          icon: const Icon(Icons.calendar_today,
                                              size: 18),
                                          label: Text(
                                            startDateController.text.isEmpty
                                                ? "From"
                                                : startDateController.text,
                                            style: const TextStyle(
                                              fontSize: 11,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFFA8D5A2),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 8,
                                            ),
                                          ),
                                          onPressed: () async {
                                            final picked = await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime.now(),
                                            );
                                            if (picked != null) {
                                              startDateController.text =
                                                  "${_twoDigits(picked.day)}/${_twoDigits(picked.month)}/${picked.year}";
                                              setState(() {});
                                            }
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          icon: const Icon(Icons.calendar_today,
                                              size: 18),
                                          label: Text(
                                            endDateController.text.isEmpty
                                                ? "To"
                                                : endDateController.text,
                                            style: const TextStyle(
                                              fontSize: 11,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFFA8D5A2),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 8,
                                            ),
                                          ),
                                          onPressed: () async {
                                            final picked = await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime.now(),
                                            );
                                            if (picked != null) {
                                              endDateController.text =
                                                  "${_twoDigits(picked.day)}/${_twoDigits(picked.month)}/${picked.year}";
                                              setState(() {});
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 14),

                            ///////////////////////////////////////////////////
                            /// SUMMARY SECTION
                            ///////////////////////////////////////////////////
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFA8D5A2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Summary",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _summaryRow("Remaining Fuel:",
                                      "${remainingFuel.toStringAsFixed(1)} L"),
                                  const SizedBox(height: 6),
                                  _summaryRow("Total Usage:",
                                      "${totalFuelUsed.toStringAsFixed(1)} L"),
                                  const SizedBox(height: 6),
                                  _summaryRow("Forecast (7d):",
                                      "${forecast7Days.toStringAsFixed(1)} L"),
                                  const SizedBox(height: 6),
                                  _summaryRow("Forecast (30d):",
                                      "${forecast30Days.toStringAsFixed(1)} L"),
                                ],
                              ),
                            ),

                            const SizedBox(height: 14),

                            ///////////////////////////////////////////////////
                            /// RECORDS TABLE
                            ///////////////////////////////////////////////////
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFD0D0D0),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  ///////////////////////////////////////////////////
                                  /// HEADER
                                  ///////////////////////////////////////////////////
                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Color(0xFFD0D0D0),
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            "Date",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[700],
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            "Hours",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[700],
                                              fontSize: 11,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            "Used",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[700],
                                              fontSize: 11,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            "Balance",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[700],
                                              fontSize: 11,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  ///////////////////////////////////////////////////
                                  /// DATA ROWS
                                  ///////////////////////////////////////////////////
                                  if (filtered.isEmpty)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      child: Text(
                                        "No records found",
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                  else
                                    ...filtered.map(
                                      (r) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4,
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                r.date,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                "${r.hours.toStringAsFixed(1)}h",
                                                textAlign: TextAlign.right,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                "${r.fuelUsed.toStringAsFixed(1)}L",
                                                textAlign: TextAlign.right,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                GeneratorModel.calculateRemaining(
                                                  capacity: widget.capacity,
                                                  usageRate:
                                                      widget.usageRate,
                                                  hours: r.hours,
                                                  fuelAdded: r.fuelAdded,
                                                ).toStringAsFixed(1),
                                                textAlign: TextAlign.right,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    ///////////////////////////////////////////////////
                    /// CLOSE BUTTON (FIXED AT BOTTOM)
                    ///////////////////////////////////////////////////
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Color(0xFFD0D0D0),
                          ),
                        ),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7FA6C9),
                            padding:
                                const EdgeInsets.symmetric(vertical: 10),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Close",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  String _twoDigits(int value) => value.toString().padLeft(2, "0");
}
