import 'package:flutter/material.dart';

import 'package:tubez/entity/JadwalTayang.dart';

class TimeWidget extends StatefulWidget {
  const TimeWidget(
      {super.key, required this.jadwalTayang, required this.onTimeSelected});
  final List<Jadwaltayang> jadwalTayang;
  final Function(int) onTimeSelected;
  @override
  State<TimeWidget> createState() => _TimeWidgetState();
}

class _TimeWidgetState extends State<TimeWidget> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final ambilJam = widget.jadwalTayang
        .map((e) => e.jadwal?.jamTayang)
        .where((jamTayang) => jamTayang != null)
        .toSet()
        .toList();

    final limaJamTayang = ambilJam.take(5).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(limaJamTayang.length, (index) {
          final jamTayang = limaJamTayang[index]!;
          final jamHHMM = jamTayang.substring(0, 5);
          final isActive = selectedIndex == index;

          return Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedIndex = index;
                });

                widget.onTimeSelected(widget.jadwalTayang[index].idJadwal!);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    isActive ? Colors.amber : Colors.transparent),
                foregroundColor: MaterialStateProperty.all(
                  isActive ? Colors.white : Colors.white,
                ),
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(
                        color: isActive ? Colors.amber : Colors.white,
                        width: 1),
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(jamHHMM, style: const TextStyle(fontSize: 10.0)),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
