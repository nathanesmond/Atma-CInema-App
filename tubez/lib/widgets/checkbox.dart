import 'package:flutter/material.dart';
import 'package:tubez/theme.dart';

class CheckBox extends StatefulWidget {
  final String text;
  const CheckBox(this.text, {super.key});
  @override
  State<CheckBox> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isSelected = !isSelected;
                });
              },
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: kDarkGreyColor)),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        size: 18,
                        color: Colors.orange,
                      )
                    : null,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Text(widget.text, style: TextStyle(color: Colors.white),),
          ],
        )
      ],
    );
  }
}
