import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taskapp/shared/task_bloc_observer.dart';

import 'modules/task_screen/task_screen.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Follow ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          elevation: 0.0,
          backgroundColor: Colors.white
        ),
        appBarTheme: AppBarTheme(
          color: Colors.white,
          elevation: 0.0,
          backwardsCompatibility: false,
        /*  titleTextStyle: TextStyle(
            color: Colors.deepOrange,
            fontSize: 20.0,
              fontWeight: FontWeight.w600
          ),*/
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white
          )
        ),
        primarySwatch: Colors.cyan,
      ),
      home: TaskScreen(),
    );
  }
}

