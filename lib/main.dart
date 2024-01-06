import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_slots_new/screens/BookingProvider.dart';

void main() async {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BookingProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Booking App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BookingWidget(),
    );
  }
}
