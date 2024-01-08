import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'booking_details.dart';

class BookingProvider with ChangeNotifier {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String collectionPath = 'bookings';

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  Set<String> bookedSlots = {};
  bool loadedBookedSlots = false;
  bool isTimeSlotAccepted = false;

  Future<void> loadBookedSlots() async {
    if (!loadedBookedSlots) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bookedSlots = prefs.getStringList('bookedSlots')?.toSet() ?? {};
      loadedBookedSlots = true;
      notifyListeners();
    }
  }

  Future<void> saveBookedSlots() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('bookedSlots', bookedSlots.toList());
  }

  void setDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
    updateFirebaseData();
  }


  void setTime(TimeOfDay time, bool isBooked) {
    final formattedTime = "${time.hour}:${time.minute}";
    final formattedDateTime = selectedDate != null
        ? "${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}-$formattedTime"
        : "";

    if (isBooked) {
      bookedSlots.add(formattedDateTime);
      isTimeSlotAccepted = true;
    } else {
      bookedSlots.remove(formattedDateTime);
      isTimeSlotAccepted = false;
    }
    selectedTime = time;
    saveBookedSlots();
    updateFirebaseData();
    notifyListeners();
  }

  bool isTimeSlotBooked(TimeOfDay time) {
    final formattedTime = "${time.hour}:${time.minute}";
    final formattedDateTime =
    selectedDate != null ? "${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}-$formattedTime" : "";
    return bookedSlots.contains(formattedDateTime);
  }


  Future<void> updateFirebaseData() async {
    if (selectedDate != null) {
      await firestore.collection(collectionPath).doc(selectedDate.toString()).set({
        'date': selectedDate,
        'bookedSlots': bookedSlots.toList(),
      });
    }
  }


}

class BookingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);
    bookingProvider.loadBookedSlots();

    final List<TimeOfDay> timeSlots = [
      TimeOfDay(hour: 9, minute: 0),
      TimeOfDay(hour: 10, minute: 0),
      TimeOfDay(hour: 11, minute: 0),
      TimeOfDay(hour: 12, minute: 0),
      TimeOfDay(hour: 13, minute: 0),
      TimeOfDay(hour: 14, minute: 0),
      TimeOfDay(hour: 15, minute: 0),
      TimeOfDay(hour: 16, minute: 0),
      TimeOfDay(hour: 17, minute: 0),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Booking App"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (selectedDate != null) {
                  bookingProvider.setDate(selectedDate);
                }
              },
              child: Text(
                "Choose Date",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 15),
              ),
            ),
            Text(
              "Selected Date: ${bookingProvider.selectedDate?.toString() ?? 'Not selected'}",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Select Time Slot:",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: (timeSlots.length / 3).ceil(),
                itemBuilder: (context, rowIndex) {
                  return Row(
                    children: List.generate(
                      3,
                      (index) {
                        final timeIndex = rowIndex * 3 + index;
                        if (timeIndex < timeSlots.length) {
                          final timeSlot = timeSlots[timeIndex];
                          final formattedTime =
                              "${timeSlot.hour}:${timeSlot.minute}";
                          final formattedDateTime = bookingProvider
                                      .selectedDate !=
                                  null
                              ? "${bookingProvider.selectedDate!.year}-${bookingProvider.selectedDate!.month}-${bookingProvider.selectedDate!.day}-$formattedTime"
                              : "";

                          return Expanded(
                            child: Container(
                              height: 45.0,
                              decoration: BoxDecoration(
                                color: bookingProvider.selectedDate != null &&
                                        bookingProvider.bookedSlots
                                            .contains(formattedDateTime)
                                    ? Colors.grey
                                    : Colors.lightGreen,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              margin: EdgeInsets.all(4.0),
                              child: ElevatedButton(
                                onPressed: bookingProvider.selectedDate != null
                                    ? () {
                                        bool isBooked = bookingProvider
                                            .isTimeSlotBooked(timeSlot);
                                        bookingProvider.setTime(
                                            timeSlot, !isBooked);
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                ),
                                child: Center(
                                  child: Text(
                                    "${timeSlot.format(context)}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (bookingProvider.selectedDate != null &&
                    bookingProvider.selectedTime != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NextScreen(
                        selectedDate: bookingProvider.selectedDate!,
                        selectedTime: bookingProvider.selectedTime!,
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.cyan,
                padding: EdgeInsets.all(15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                "BOOK APPOINTMENT",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
