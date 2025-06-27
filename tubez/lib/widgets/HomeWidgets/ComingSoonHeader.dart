import 'package:flutter/material.dart';
import 'package:tubez/screens/seeMoreScreen.dart';

class ComingSoonHeader extends StatelessWidget {
  const ComingSoonHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 12),
          child: const Text(
            'Coming Soon ',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.only(right: 12),
          child: TextButton(
            onPressed: () {
              pushSeeMore(context);
            },
            child: const Text('see more ',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.amber,
                )),
          ),
        ),
      ],
    );
  }

  void pushSeeMore(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const seeMoreScreen(index: 1),
      ),
    );
  }
}
