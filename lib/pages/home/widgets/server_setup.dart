import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:log_app/pages/home/bloc/home_bloc.dart';
import 'package:log_app/pages/home/functions.dart';
import 'package:log_app/strings.dart';

class ServerSetup extends StatelessWidget {
  const ServerSetup({super.key});

  @override
  Widget build(BuildContext context) {
    var hostnameC = TextEditingController();
    var usernameC = TextEditingController();
    var passwordC = TextEditingController();
    var databaseC = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text(Strings.serverSetup)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (hostnameC.text == "" || usernameC.text == ""
              || passwordC.text == "" || databaseC.text == "") {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(Strings.allFields),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }

          if (await checkServerConnection(
            hostname: hostnameC.text,
            username: usernameC.text,
            password: passwordC.text,
            database: databaseC.text,
          )) {
            await GetStorage().write(
              'serverConfig',
              <String>[hostnameC.text, usernameC.text, passwordC.text, databaseC.text],
            );

            // ignore: use_build_context_synchronously
            context.read<HomeBloc>().add(LoadHome());
          }
        },
        icon: const Icon(Icons.check),
        label: Text(Strings.confirm),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: hostnameC,
              autocorrect: false,
              keyboardType: TextInputType.url,
              decoration: InputDecoration(
                label: Text(Strings.hostname),
                hintText: Strings.hostnameHint,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: usernameC,
              autocorrect: false,
              decoration: InputDecoration(
                label: Text(Strings.username),
                hintText: Strings.usernameHint,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: passwordC,
              autocorrect: false,
              obscureText: true,
              decoration: InputDecoration(
                label: Text(Strings.password),
                hintText: Strings.passwordHint,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: databaseC,
              autocorrect: false,
              decoration: InputDecoration(
                label: Text(Strings.database),
                hintText: Strings.databaseHint,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}