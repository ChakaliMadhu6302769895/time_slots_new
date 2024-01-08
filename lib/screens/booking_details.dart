import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'BookingProvider.dart';

class NextScreen extends StatefulWidget {
  final DateTime selectedDate;
  final TimeOfDay selectedTime;

  NextScreen({required this.selectedDate, required this.selectedTime});

  @override
  _NextScreenState createState() => _NextScreenState();
}

class _NextScreenState extends State<NextScreen> {
  bool isAccepted = false;
  bool isDeclined = false;

  @override
  Widget build(BuildContext context) {
    BookingProvider bookingProvider = Provider.of<BookingProvider>(context, listen: false);

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
              "Selected Date: ${widget.selectedDate.toString()}",
              style: TextStyle(fontSize: 18),
            ),
            Text(
              "Selected Time: ${widget.selectedTime.format(context)}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                handleAccept(context, bookingProvider, widget.selectedTime);
                setState(() {
                  isAccepted = !isAccepted;
                });
              },
              style: ElevatedButton.styleFrom(
                primary: isAccepted ? Colors.grey : Colors.blue,
                padding: EdgeInsets.all(15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                isAccepted ? "Accepted" : "Accept",
                style: TextStyle(fontSize: 18 , color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                handleDecline(context, bookingProvider, widget.selectedTime);
                setState(() {
                  isDeclined = !isDeclined;
                });
              },
              style: TextButton.styleFrom(
                backgroundColor: isDeclined ? Colors.red : Colors.green,
                padding: EdgeInsets.all(15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                isDeclined ? "Declined" : "Decline",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }


  void handleAccept(BuildContext context, BookingProvider bookingProvider, TimeOfDay selectedTime) {
    bool isBooked = bookingProvider.isTimeSlotBooked(selectedTime);

    if (!isBooked && !bookingProvider.isTimeSlotAccepted) {
      bookingProvider.setTime(selectedTime, true);
      bookingProvider.isTimeSlotAccepted = true;
      bookingProvider.notifyListeners();
    }
  }

  void handleDecline(BuildContext context, BookingProvider bookingProvider, TimeOfDay selectedTime) {
    bool isBooked = bookingProvider.isTimeSlotBooked(selectedTime);

    if (isBooked) {
      bookingProvider.setTime(selectedTime, false);
      bookingProvider.notifyListeners();
    }
  }
}
