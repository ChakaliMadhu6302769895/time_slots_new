import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'booking_details.dart';

class BookingProvider with ChangeNotifier {
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
  }

  void setTime(TimeOfDay time, bool isBooked) {
    final formattedTime = "${time.hour}:${time.minute}";
    final formattedDateTime = selectedDate != null
        ? "${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}-$formattedTime"
        : "";

    if (isBooked) {
      bookedSlots.add(formattedDateTime);
      isTimeSlotAccepted = true; // Set the flag to true when time slot is accepted
    } else {
      bookedSlots.remove(formattedDateTime);
      isTimeSlotAccepted = false; // Reset the flag when time slot is declined
    }


    selectedTime = time;
    saveBookedSlots();
    notifyListeners();
  }

  bool isTimeSlotBooked(TimeOfDay time) {
    final formattedTime = "${time.hour}:${time.minute}";
    final formattedDateTime =
    selectedDate != null ? "${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}-$formattedTime" : "";
    return bookedSlots.contains(formattedDateTime);
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
                                    ? Colors
                                        .grey // Indicator for booked time slot on the selected date
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
                                // Disable the button if selectedDate is null
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
              child: Text(
                "BOOK APPOINTMENT",
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
