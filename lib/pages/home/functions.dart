
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:log_app/pages/home/bloc/functions.dart';
import 'package:log_app/pages/home/bloc/home_bloc.dart';
import 'package:log_app/strings.dart';

Future<void> refresh(BuildContext context) async {
  try {
    context.read<HomeBloc>().add(UpdateHome(await getTables()));
  } catch (e) {
    context.read<HomeBloc>().add(ReportHomeError());
  }
}

Future<void> addNewTableDialog(BuildContext context) async {
  TextEditingController controller = TextEditingController();
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(Strings.newLog),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            label: Text(Strings.listName),
            hintText: Strings.newListHint,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(Strings.cancel),
          ),
          TextButton(
            onPressed: () {
              context.read<HomeBloc>().add(
                InsertHome(controller.text),
              );
              Navigator.pop(context);
            },
            child: Text(Strings.create),
          ),
        ],
      );
    },
  );
}
