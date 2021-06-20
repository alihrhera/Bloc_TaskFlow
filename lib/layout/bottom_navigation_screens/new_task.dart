import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskapp/shared/components/components.dart';
import 'package:taskapp/shared/components/constants.dart';
import 'package:taskapp/shared/cubit/app_states.dart';
import 'package:taskapp/shared/cubit/cubit.dart';

class NewTask extends StatelessWidget {


  @override
  Widget build(BuildContext context) {


    return BlocConsumer<TaskCubit,AppStates>(builder: (context, state){
      var newTaskList = TaskCubit.get(context).newTasks;
      return taskBuilder(taskList: newTaskList);
    }, listener: (context,state){});
  }
}
