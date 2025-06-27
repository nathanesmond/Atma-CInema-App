import 'package:flutter/material.dart';
import 'package:tubez/service/directToLink.dart';

class LoginOption extends StatelessWidget {
  const LoginOption({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Direct.launchURL('https://www.facebook.com/');
          },
          child: const Image(
            height: 35,
            width: 35,
            image: AssetImage('assets/images/facebook.png'),
          ),
        ),
        const SizedBox(width: 20), // Add some spacing between the buttons
        GestureDetector(
          onTap: () {
            Direct.launchURL('https://www.google.com/');
          },
          child: const Image(
            height: 35,
            width: 35,
            image: AssetImage('assets/images/gugel.png'),
          ),
        ),
      ],
    );
  }
}

class BuildButton extends StatelessWidget {
  final Image iconImage;
  const BuildButton(
      {super.key, required this.iconImage, required Null Function() onPressed});
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return SizedBox(
      height: mediaQuery.height * 0.06,
      width: mediaQuery.width * 0.16,
      child: iconImage,
    );
  }
}
