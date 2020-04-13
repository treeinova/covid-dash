import 'package:covid_dash/bloc/covid/covid_bloc.dart';
import 'package:covid_dash/screens/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Covid Dash',
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          backgroundColor: Colors.white,
          primaryColor: Color(0xFF2FBCA1),
          fontFamily: 'Poppins',
          iconTheme: IconThemeData(color: Colors.white),
          primaryTextTheme: TextTheme(
              body1: TextStyle(decoration: TextDecoration.none),
              title: TextStyle(
                  fontSize: 23,
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          textTheme: TextTheme(
              body1: TextStyle(decoration: TextDecoration.none),
              title: TextStyle(
                  fontSize: 23,
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontWeight: FontWeight.bold))),
      home: BlocProvider(
          create: (context) => CovidBloc(), child: VisaoGeralScreen()),
    );
  }
}
