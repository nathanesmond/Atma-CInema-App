import 'package:flutter/material.dart';
import 'package:tubez/entity/JadwalTayang.dart';

class cinemaTypeWidget extends StatefulWidget {
  const cinemaTypeWidget(
      {super.key, required this.jadwalTayang, required this.onTimeSelected});
  final List<Jadwaltayang> jadwalTayang;
  final Function(int) onTimeSelected;

  @override
  State<cinemaTypeWidget> createState() => _cinemaTypeWidgetState();
}

class _cinemaTypeWidgetState extends State<cinemaTypeWidget> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ambilJenis = widget.jadwalTayang
        .map((e) => e.studio?.jenis)
        .where((jenis) => jenis != null)
        .toSet()
        .toList();

    print('Jenis Studio nya: $ambilJenis');

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(ambilJenis.length, (index) {
          final isActive = selectedIndex == index;
          final jenisStudio = ambilJenis[index]!;

          return Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedIndex = index;
                });
                var selectedJadwal = widget.jadwalTayang.firstWhere(
                    (jadwal) => jadwal.studio?.jenis == jenisStudio);
                widget.onTimeSelected(selectedJadwal.idStudio!);
              },
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                    isActive ? Colors.amber : Colors.transparent),
                foregroundColor: WidgetStatePropertyAll(
                  isActive ? Colors.white : Colors.white,
                ),
                padding: WidgetStatePropertyAll(
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 18.0),
                ),
                shape: WidgetStatePropertyAll(
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
                  Text(
                    jenisStudio,
                    style: const TextStyle(fontSize: 12.0),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
