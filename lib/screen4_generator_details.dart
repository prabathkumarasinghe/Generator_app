import 'package:flutter/material.dart';
import 'screen1_runtime_fuel.dart';
import 'screen2_generator_list.dart';
import 'screen3_add_generator.dart';

class Screen4 extends StatefulWidget {
  final String name;
  final String code;
  final String fuel;

  const Screen4({
    super.key,
    required this.name,
    required this.code,
    required this.fuel,
  });

  @override
  State<Screen4> createState() => _Screen4State();
}

class _Screen4State extends State<Screen4> {
  int _selectedIndex = 1;

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
        title: Text(widget.name, style: TextStyle(color: Colors.white),),
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

            _label("Fuel Tank Capacity"),
            _input("120L"),

            _label("Fuel Usage Rate"),
            _input("10L/hr"),

            _label("Fuel remaining"),
            _input(widget.fuel),

            const SizedBox(height: 30),

            /////////////////////////////////////////////////////
            /// 🔹 BUTTONS
            /////////////////////////////////////////////////////
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _button("Update"),
                _button("Report", onPressed: () {
                  _showReportDialog(context);
                }),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "",
          ),
          BottomNavigationBarItem(
            //icon: Icon(Icons.electrical_services),
            //label: "",
              icon: Icon(Icons.local_gas_station), label: ""),

          BottomNavigationBarItem(
            icon: Icon(Icons.edit_document),
            label: "",
          ),
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
      child: Text(
        text,
        style: const TextStyle(color: Colors.grey),
      ),
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
      child: Text(
        value,
        style: const TextStyle(color: Colors.black54),
      ),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      onPressed: onPressed ?? () {},
      child: Text(text),
    );
  }

  ///////////////////////////////////////////////////////////
  /// 🔹 REPORT POPUP
  ///////////////////////////////////////////////////////////
  void _showReportDialog(BuildContext context) {
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
                /// HEADER
                ///////////////////////////////////////////////////
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Date"),
                    Text("Run time(Hr)"),
                    Text("Usage(L)"),
                    Text("Balance(L)"),
                  ],
                ),

                const SizedBox(height: 16),

                ///////////////////////////////////////////////////
                /// DATA ROWS
                ///////////////////////////////////////////////////
                _reportRow("20/04/2025", "4", "25", "10"),
                const SizedBox(height: 10),
                _reportRow("25/04/2025", "10", "50", "20"),

                const SizedBox(height: 20),

                ///////////////////////////////////////////////////
                /// EXIT BUTTON
                ///////////////////////////////////////////////////
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Exit"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ///////////////////////////////////////////////////////////
  /// 🔹 REPORT ROW
  ///////////////////////////////////////////////////////////
  Widget _reportRow(
      String date, String runtime, String usage, String balance) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(date),
        Text(runtime),
        Text(usage),
        Text(balance),
      ],
    );
  }
}