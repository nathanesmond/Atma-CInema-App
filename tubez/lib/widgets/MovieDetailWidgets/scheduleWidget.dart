import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tubez/entity/JadwalTayang.dart';

class Schedulewidget extends StatefulWidget {
  const Schedulewidget(
      {super.key, required this.jadwalTayang, required this.onTimeSelected});
  final List<Jadwaltayang> jadwalTayang;
  final Function(DateTime) onTimeSelected;

  @override
  State<Schedulewidget> createState() => _SchedulewidgetState();
}

class _SchedulewidgetState extends State<Schedulewidget> {
  int selectedIndex = 0;

  // Function to format the DateTime to String (dd/MM/yyyy)
  String formatDate(DateTime dateTime) {
    if (dateTime == null) {
      return 'NO DATE';
    }
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final uniqueDates = widget.jadwalTayang
        .map((e) => e.tanggalTayang)
        .where((date) => date != null)
        .toSet()
        .toList();

    final limitedDates = uniqueDates.take(5).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(limitedDates.length, (index) {
          final date = limitedDates[index];

          final isActive = selectedIndex == index;
          final dayName = index == 0 ? "Today" : "Day ${index + 1}";
          final dayNumber = DateFormat('dd').format(date);

          return Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedIndex = index; // Update selected index
                });
                widget.onTimeSelected(date!);
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  isActive ? Colors.amber : Colors.transparent,
                ),
                foregroundColor: WidgetStateProperty.all(
                  isActive ? Colors.white : Colors.white,
                ),
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(
                        color: isActive ? Colors.amber : Colors.white,
                        width: 1),
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(dayName, style: const TextStyle(fontSize: 12.0)),
                  const SizedBox(height: 4),
                  Text(dayNumber, style: const TextStyle(fontSize: 14.0)),
                ],
              ), // Show the formatted date as text
            ),
          );
        }),
      ),
    );
  }
}
