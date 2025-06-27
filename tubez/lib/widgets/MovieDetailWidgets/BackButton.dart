import 'package:flutter/material.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20.0,
      left: 20.0,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 131, 127, 127).withOpacity(0.6),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Transform.translate(
              offset: Offset(4, 0),
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
