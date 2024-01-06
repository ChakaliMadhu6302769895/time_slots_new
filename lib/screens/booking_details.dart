import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NextScreen extends StatelessWidget {
  final DateTime selectedDate;
  final TimeOfDay selectedTime;

  NextScreen({required this.selectedDate, required this.selectedTime});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Next Screen"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Selected Date: ${selectedDate.toString()}",
              style: TextStyle(fontSize: 18),
            ),
            Text(
              "Selected Time: ${selectedTime.format(context)}",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
