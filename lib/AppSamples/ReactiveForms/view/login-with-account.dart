import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/AppSamples/ReactiveForms/config/appconfig.dart';
import 'package:newsee/AppSamples/ReactiveForms/view/loginwithblocprovider.dart';
import 'package:newsee/Model/login_request.dart';
import 'package:newsee/blocs/login/login_bloc.dart';
import 'package:newsee/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

void loginActionSheet(BuildContext context) {
  final double screenwidth = MediaQuery.of(context).size.width;
  final double screenheight = MediaQuery.of(context).size.height;

  showCupertinoModalPopup(
    context: context,

    builder:
        (BuildContext context) => SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(126, 1, 1, 129),
                  const Color.fromARGB(64, 1, 1, 129),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.all(10),
            width: screenwidth * 1.0,
            height: screenheight * 0.6,
            child: LoginBlocProvide(),
          ),
        ),
  );
}

class LoginpageWithAC extends StatelessWidget {
  const LoginpageWithAC({super.key});

  @override
  Widget build(BuildContext context) {
    final loginFormgroup = AppConfig().loginFormgroup;

    login(AuthState state) {
      if (loginFormgroup.valid) {
        context.read<AuthBloc>().add(
          LoginWithAccount(
            loginRequest: LoginRequest(
              username: loginFormgroup.value['username'] as String,
              password: loginFormgroup.value['password'] as String,
            ),
          ),
        );
        print(state.toString());

        //context.goNamed('home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all required fields')),
        );
      }
    }

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        switch (state.authStatus) {
          case AuthStatus.success:
            print('LoginStatus.success...');
            context.goNamed('home');
          case AuthStatus.loading:
            print('LoginStatus.loading...');

          case AuthStatus.init:
            print('LoginStatus.init...');

          case AuthStatus.failure:
            print('LoginStatus.error...');

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Login Failed...')),
            );
        }
        ;
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final isLoading = state.authStatus == AuthStatus.loading;
          print('state.authStatus => ${state.authStatus}');
          final isPasswordHidden = state.isPasswordHidden;
          print(
            'in build function isPasswordHidden=> ${state.isPasswordHidden}',
          );
          return Container(
            // padding: const EdgeInsets.only(top: 20),
            // height: double.infinity,
            // width: double.infinity,
            // decoration: BoxDecoration(

            // ),
            child: SingleChildScrollView(
              child: Container(
                child: ReactiveForm(
                  formGroup: loginFormgroup,
                  child: Center(
                    child: Container(
                      width: 300,
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20, top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Login Account",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                          ReactiveTextField(
                            formControlName: 'username',
                            autofocus: true,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              suffixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validationMessages: {
                              ValidationMessage.required:
                                  (error) => 'UserName is Required',
                              ValidationMessage.contains:
                                  (error) => error as String,
                            },
                          ),
                          SizedBox(height: 10.0),

                          ReactiveTextField(
                            formControlName: 'password',
                            obscureText: isPasswordHidden,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isPasswordHidden
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  context.read().add(PasswordSecure());
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validationMessages: {
                              ValidationMessage.required:
                                  (error) => 'Password is Required',
                              ValidationMessage.contains:
                                  (error) => error as String,
                            },
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            style: const ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll<Color>(
                                Color.fromARGB(255, 2, 59, 105),
                              ),
                              foregroundColor: WidgetStatePropertyAll(
                                Colors.white,
                              ),
                              minimumSize: WidgetStatePropertyAll(
                                Size(230, 40),
                              ),
                            ),
                            onPressed:
                                isLoading
                                    ? null
                                    : () {
                                      login(state);
                                    },
                            child:
                                isLoading
                                    ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.0,
                                      ),
                                    )
                                    : const Text("Login"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
