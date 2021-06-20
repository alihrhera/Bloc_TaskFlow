import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taskapp/layout/bottom_navigation_screens/archive_task.dart';
import 'package:taskapp/layout/bottom_navigation_screens/done_task.dart';
import 'package:taskapp/layout/bottom_navigation_screens/new_task.dart';
import 'package:taskapp/shared/cubit/app_states.dart';

class TaskCubit extends Cubit<AppStates> {

  TaskCubit() : super(InitialState());

  static TaskCubit get(context) => BlocProvider.of(context);
  bool isBottomSheetOpen = true;
  int currentIndex = 0;
  IconData fabIcon = Icons.edit;
  Database database;
  List<Map> newTasks =[];
  List<Map> doneTasks =[];
  List<Map> archiveTasks =[];
  List<Widget> screens = [
    NewTask(),
    DoneTask(),
    ArchiveTask(),
  ];
  List<String> appBarTitle = [
    'New Tasks',
    'Done Tasks',
    'Archive Tasks',
  ];

  void changeFabIcon({IconData icon , bool isShow}){
    fabIcon = icon;
    isBottomSheetOpen=isShow;
    emit(AppChangeFabIcon());
  }
  void changeIndex ({@required int index}){
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }
  void createDateBase() async {
   openDatabase(
      'Tasks.db',
      version: 2,
      onCreate: (database, index) async {
        await database.execute(
            'CREATE TABLE Task (id INTEGER PRIMARY KEY, title TEXT, time TEXT, date TEXT, status TEXT)');
      },
      onOpen: (database) async {
        print('DataBase open');

        getFromDataBase(database);

      },
    ).catchError((onError) {
      print('$onError');
    }).then((value) {
       database = value;
       emit(AppDataBaseCreateState());


    });
  }
   insertToDataBase({String title, String time, String date}) async {
     await database
        .transaction((txn) => txn.rawInsert(
        'INSERT INTO Task(title, time, date, status) VALUES("$title", "$time", "$date", "New")'))
        .then((value) {
      emit(AppDataBaseInsertState());
     getFromDataBase(database);
    })
        .onError((error, stackTrace) {
      print('${error.toString()}' + '${stackTrace.toString()}');
    }
        ).catchError((onError)=> print('Insert Error $onError'));
  }

  void updateDateBase({String status, int id}) async {
     database.rawUpdate('UPDATE Task SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
       emit(AppDataBaseUpdateState());
       getFromDataBase(database);
     }).catchError((onError) {
       print(onError.toString());
     });
  }

  void deleteFromDataBase({int id}) async {
    await database.rawDelete('DELETE FROM Task WHERE id = ?', [id]).then(
            (value) {
              getFromDataBase(database);
            });
  }

  void getFromDataBase(Database database) async {
    newTasks= [];
    doneTasks= [];
    archiveTasks= [];
   await database.rawQuery('SELECT * FROM Task').then((value) {

      value.forEach((element) {
        if(element['status'] == 'New'){
          newTasks.add(element);
          print('new Tasks $newTasks');
        }else if(element['status'] == 'Done'){
          doneTasks.add(element);
          print('done Tasks $doneTasks');
        }else{
          archiveTasks.add(element);
          print('archive Tasks $archiveTasks');
        }
        emit(AppGetDataDataBaseState());
      });
    }).catchError((onError)=> print('GetDataError $onError'));
  }

}