import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskapp/shared/components/components.dart';
import 'package:taskapp/shared/components/constants.dart';
import 'package:taskapp/shared/cubit/app_states.dart';
import 'package:taskapp/shared/cubit/cubit.dart';

class DoneTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    return BlocConsumer<TaskCubit,AppStates>(builder: (context, state){
      var doneTaskList = TaskCubit.get(context).doneTasks;
      return  taskBuilder(taskList: doneTaskList);
    }, listener: (context,state){});
  }
}
