import 'dart:async';
import 'package:flutter/material.dart';
import 'package:weatherapp/screen.dart/weather_screen.dart';

class MysplachScreen extends StatefulWidget {
  const MysplachScreen({super.key});

  @override
  State<MysplachScreen> createState() => _MysplachScreenState();
}

class _MysplachScreenState extends State<MysplachScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WeatherScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 30,
                child: Text(
                  'W',
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              SizedBox(width: 5),
              Text(
                'eather updates',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )
            ],
          ),
        ));
  }
}
