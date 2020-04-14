import 'package:app_covid_dash/covid/index.dart';
import 'package:app_covid_dash/screens/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/splash_screen.dart';

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
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [const Locale('pt')],
      home: BlocProvider(
          create: (context) => CovidBloc()..add(LoadDataCovid()),
          child: BlocBuilder<CovidBloc, CovidState>(
            builder: (context, state) {
              if (state is DataCovidLoaded) {
                return VisaoGeralScreen();
              }

              return SplashScreen();
            },
          )),
    );
  }
}
