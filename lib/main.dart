import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_slots_new/screens/BookingProvider.dart';

void main() async {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BookingWidget(),
    );
  }
}