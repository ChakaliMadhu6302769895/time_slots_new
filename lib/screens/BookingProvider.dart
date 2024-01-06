import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_slots_new/screens/booking_details.dart';

class BookingProvider with ChangeNotifier {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  Set<String> bookedSlots = {};
  bool loadedBookedSlots = false;

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

  void setTime(TimeOfDay time) {
    final formattedTime = "${time.hour}:${time.minute}";

    // Check if the time slot is already booked
    if (bookedSlots.contains(formattedTime)) {
      // Unbook the time slot if it is already booked
      bookedSlots.remove(formattedTime);
    } else {
      // Book the time slot if it is not booked
      bookedSlots.add(formattedTime);
    }

    selectedTime = time;
    saveBookedSlots();
    notifyListeners();
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
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),
              ),
            ),
            Text(
              "Selected Date: ${bookingProvider.selectedDate?.toString() ?? 'Not selected'}",
              style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Select Time Slot:",
              style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
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
                          final formattedTime = "${timeSlot.hour}:${timeSlot.minute}";
                          return Expanded(
                            child: Container(
                              height: 45.0,
                              decoration: BoxDecoration(
                                // Inside the ListView.builder, modify the color logic for each time slot
                                color: (bookingProvider.selectedDate != null &&
                                    bookingProvider.bookedSlots.contains(formattedTime))
                                    ? Colors.brown // Indicator for booked time slot on the selected date
                                    : Colors.blue,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              margin: EdgeInsets.all(4.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  bookingProvider.setTime(timeSlot);
                                },
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
                if (bookingProvider.selectedDate != null && bookingProvider.selectedTime != null) {
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