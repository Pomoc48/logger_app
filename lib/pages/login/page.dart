import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger_app/pages/home/bloc/home_bloc.dart';
import 'package:logger_app/pages/login/bloc/login_bloc.dart';
import 'package:logger_app/strings.dart';
import 'package:logger_app/widgets/fader.dart';
import 'package:logger_app/widgets/loading.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginAccepted) {
          BlocProvider.of<HomeBloc>(context).add(LoadHome(state.token));
          Navigator.pushReplacementNamed(context, Routes.home);
        }

        if (state is LoginMessage) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder:(context, state) {
        if (state is LoginRequired || state is LoginMessage) {
          TextEditingController username = TextEditingController();
          TextEditingController password = TextEditingController();

          return Fader(
            child: Scaffold(
              appBar: AppBar(title: Text(Strings.login)),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  context.read<LoginBloc>().add(RequestLogin(
                    username: username.text,
                    password: password.text,
                  ));
                },
                icon: const Icon(Icons.login),
                label: Text(Strings.login),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: username,
                      decoration: InputDecoration(
                        label: Text(Strings.username),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: password,
                      obscureText: true,
                      decoration: InputDecoration(
                        label: Text(Strings.password),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {},
                      child: Text(Strings.createUser),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return const PageLoading();
      }
    );
  }
}