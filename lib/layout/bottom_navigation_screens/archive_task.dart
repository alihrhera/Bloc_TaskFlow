import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskapp/shared/components/components.dart';
import 'package:taskapp/shared/cubit/app_states.dart';
import 'package:taskapp/shared/cubit/cubit.dart';

class ArchiveTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return BlocConsumer<TaskCubit, AppStates>(

        builder: (context, state) {
          var archiveList = TaskCubit.get(context).archiveTasks;
          return taskBuilder(taskList: archiveList);
        },
        listener: (context, state) {});
  }
}
