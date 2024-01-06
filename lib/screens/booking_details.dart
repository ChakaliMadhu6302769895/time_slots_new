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
      body: Container(
        padding: EdgeInsets.all(20.0),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle the action for the first button
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                padding: EdgeInsets.all(15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                "Button 1",
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Handle the action for the second button
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.all(15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                "Button 2",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
