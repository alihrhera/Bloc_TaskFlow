import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:taskapp/shared/components/components.dart';
import 'package:taskapp/shared/cubit/app_states.dart';
import 'package:taskapp/shared/cubit/cubit.dart';

// ignore: must_be_immutable
class TaskScreen extends StatelessWidget {
  var titleEditingController = TextEditingController();
  var timeEditingController = TextEditingController();
  var dateEditingController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskCubit()..createDateBase(),
      child: BlocConsumer<TaskCubit, AppStates>(
          builder: (context, state) {
            TaskCubit appCubit = TaskCubit.get(context);
            return Scaffold(
              key: scaffoldKey,
              floatingActionButton: FloatingActionButton(
                child: Icon(appCubit.fabIcon, color: Theme.of(context).primaryColor,),
                onPressed: () {
                  if (appCubit.isBottomSheetOpen) {
                    scaffoldKey.currentState
                        .showBottomSheet((context) => Container(
                              color: Colors.white,
                              padding: EdgeInsets.all(20.0),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    defaultFormField(
                                        controller: titleEditingController,
                                        hint: 'Task ',
                                        icon: Icons.title),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    defaultFormField(
                                        controller: timeEditingController,
                                        hint: 'Time',
                                        icon: Icons.timer,
                                        onTap: () {
                                          showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now())
                                              .then((value) =>
                                                  timeEditingController.text =
                                                      value
                                                          .format(context)
                                                          .toString());
                                        }),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    defaultFormField(
                                        controller: dateEditingController,
                                        hint: 'Date',
                                        icon: Icons.date_range,
                                        onTap: () {
                                          showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime.now(),
                                                  lastDate: DateTime.now())
                                              .then((value) =>
                                                  dateEditingController.text =
                                                      DateFormat.yMMMd()
                                                          .format(value));
                                        }),
                                  ],
                                ),
                              ),
                            ))
                        .closed
                        .then((value) => {
                              appCubit.changeFabIcon(
                                  icon: Icons.edit, isShow: true)
                            });

                    //appCubit.isBottomSheetOpen = false;
                    appCubit.changeFabIcon(icon: Icons.add, isShow: false);
                  } else {
                    appCubit.isBottomSheetOpen = true;
                    if (formKey.currentState.validate()) {
                      appCubit.insertToDataBase(
                        title: titleEditingController.text,
                        time: timeEditingController.text,
                        date: dateEditingController.text,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Processing Data')));

                    }
                    appCubit.changeFabIcon(icon: Icons.edit, isShow: true);
                  }
                },
              ),
              appBar: AppBar(
                title: Text(appCubit.appBarTitle[appCubit.currentIndex]),
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: appCubit.currentIndex,
                onTap: (index) {
                  appCubit.changeIndex(index: index);
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.menu), label: 'New Task'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.done_outline_rounded),
                      label: 'Done Task'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive_outlined),
                      label: 'Archive Task'),
                ],
              ),
              body: appCubit.screens[appCubit.currentIndex],
            );
          },
          listener: (context, state) {
            if(state is AppDataBaseInsertState)
              Navigator.pop(context);
          }),
    );
  }
}
