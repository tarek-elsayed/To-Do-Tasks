import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:untitled2/shared/components/components.dart';
import 'package:untitled2/shared/cubit/cubit.dart';
import 'package:untitled2/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  TextEditingController title = new TextEditingController();
  TextEditingController time = new TextEditingController();
  TextEditingController date = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {
            if(state is AppInsertDataBaseState){
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            AppCubit cubit = AppCubit.get(context);
            return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                title: Text(
                  cubit.titles[cubit.currentIndex],
                ),
              ),
              body: ConditionalBuilder(
                condition: state is! AppGetDataBaseLoadingState,
                builder: (context) =>
                cubit.screens[cubit.currentIndex],
                fallback: (context) =>
                    Center(
                      child: CircularProgressIndicator(),
                    ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (cubit.isBottomSheetShow) {
                    if (formKey.currentState.validate()) {
                      cubit.insertToDatabase(
                          title: title.text, date: date.text, time: time.text)
                          .then((value) {
                        // cubit.getDataFromDatabase(cubit.database);
                      });
                    }
                  } else {
                    scaffoldKey.currentState
                        .showBottomSheet(
                            (context) =>
                            Container(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      defaultFormField(
                                        controller: title,
                                        type: TextInputType.text,
                                        onTap: () {
                                          print('taped');
                                        },
                                        validation: (String value) {
                                          if (value.isEmpty) {
                                            return "Title is empty";
                                          }
                                          return null;
                                        },
                                        labelText: "Task Title",
                                        prefix: Icons.title,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      defaultFormField(
                                        controller: time,
                                        type: TextInputType.datetime,
                                        onTap: () {
                                          showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                              .then((value) {
                                            time.text = value
                                                .format(context)
                                                .toString();
                                          });
                                        },
                                        validation: (String value) {
                                          if (value.isEmpty) {
                                            return "Time is empty";
                                          }
                                          return null;
                                        },
                                        labelText: "Task Time",
                                        prefix: Icons.watch_later_outlined,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      defaultFormField(
                                        controller: date,
                                        type: TextInputType.datetime,
                                        onTap: () {
                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                            DateTime.parse("2021-10-03"),
                                          ).then((value) {
                                            date.text = DateFormat.yMMMd()
                                                .format(value);
                                          });
                                        },
                                        validation: (String value) {
                                          if (value.isEmpty) {
                                            return "date is empty";
                                          }
                                          return null;
                                        },
                                        labelText: "Task Date",
                                        prefix: Icons.calendar_today,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        elevation: 20.0)
                        .closed
                        .then((value) {
                   cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);
                    });
                    cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                  }
                },
                child: Icon(cubit.fabIcon),
              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.currentIndex,
                onTap: (index) {
                  cubit.changeIndex(index);
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.menu,
                      ),
                      label: "Tasks"),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.check_circle_outline,
                      ),
                      label: "Done"),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.archive_outlined,
                      ),
                      label: "Archived"),
                ],
              ),
            );

          }

      ),
    );
  }


}
