import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class CountDown extends StatefulWidget {
  const CountDown({super.key});

  @override
  _CountDownState createState() => _CountDownState();
}

class _CountDownState extends State<CountDown> {
  late Timer _timer;
  late int _remainingTime; // Remaining time in seconds
  late DateTime _endTime; // The end time when the countdown finishes

  @override
  void initState() {
    super.initState();
    _loadTimer();
  }

  // Load the timer from SharedPreferences or set a default end time
  Future<void> _loadTimer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? savedEndTime = prefs.getInt('endTime');

    if (savedEndTime != null) {
      _endTime = DateTime.fromMillisecondsSinceEpoch(savedEndTime);
    } else {
      // Set default 3 minutes countdown
      _endTime = DateTime.now().add(Duration(minutes: 3));
      prefs.setInt('endTime', _endTime.millisecondsSinceEpoch);
    }

    _startTimer();
  }

  // Start or update the countdown timer
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _remainingTime = _endTime.difference(DateTime.now()).inSeconds;

        if (_remainingTime <= 0) {
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width, // Take up full width
      height: 40,
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 63, 62, 62),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(
              "Complete order in",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.amber),
            ),
            Spacer(),
            Text(
              _remainingTime > 0
                  ? _formatTime(_remainingTime)
                  : "00:00",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.amber),
            )
          ],
        ),
      ),
    );
  }
}
