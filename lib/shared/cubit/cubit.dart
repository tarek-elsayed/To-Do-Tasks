import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled2/modules/archived_tasks/archived_tasks.dart';
import 'package:untitled2/modules/done_tasks/done_tasks.dart';
import 'package:untitled2/modules/new_tasks/new_tasks.dart';
import 'package:untitled2/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Widget> screens = [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];

  List<String> titles = [
    "Tasks",
    "Done Tasks",
    "Archived Tasks",
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  List<Map> newTask = [];
  List<Map> doneTask = [];
  List<Map> archiveTask = [];
  Database database;

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        database
            .execute(
              "CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)",
            )
            .then((value) {})
            .catchError((error) {
          print("${error.toString()}");
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
      },
    ).then((value) {
      database = value;
      emit(AppCreateDataBaseState());
    });
  }

  insertToDatabase({
    @required String title,
    @required String time,
    @required String date,
  }) async {
    await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO tasks(title,Time,date,status) VALUES("$title","$time","$date","new")')
          .then((value) {
        print("$value insert successfully");
        emit(AppInsertDataBaseState());
        getDataFromDatabase(database);
      }).catchError((onError) {
        print("insert failed");
      });
      return null;
    });
  }

  void getDataFromDatabase(database) {
    newTask = [];
    doneTask = [];
    archiveTask = [];

    emit(AppGetDataBaseLoadingState());

    database.rawQuery("SELECT * FROM tasks").then((value) {
      value.forEach((element) {
        print("element(${element['status']})");

        if (element['status'] == 'new') {
          newTask.add(element);
        } else if (element['status'] == 'done') {
          doneTask.add(element);
        } else
          archiveTask.add(element);
      });
      emit(AppGetDataBaseState());
    });
  }

  void updateData({
    @required String status,
    @required int id,
  }) async {
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDataBaseState());
    });
  }


  void deleteData({
    @required int id,
  }) async {
    database.rawDelete('Delete FROM tasks WHERE id = ?',[id])
    .then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDataBaseState());
    });
  }

  bool isBottomSheetShow = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
    @required bool isShow,
    @required IconData icon,
  }) {
    isBottomSheetShow = isShow;
    fabIcon = icon;

    emit(AppChangeBottomNavBarState());
  }
}
