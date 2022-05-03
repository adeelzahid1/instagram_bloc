import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_bloc/blocs/login/login_cubit.dart';
import 'package:instagram_bloc/repositories/auth_repository.dart';
import 'package:instagram_bloc/screens/signup_screen.dart';
import 'package:instagram_bloc/utils/error_dialog.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  static const String routeName = '/login';
  static Route route() {
    return PageRouteBuilder(
        settings: const RouteSettings(name: routeName),
        transitionDuration: const Duration(seconds: 0),
        pageBuilder: (context, __, ___) => BlocProvider<LoginCubit>(
              create: (_) =>
                  LoginCubit(authRepository: context.read<AuthRepository>()),
              child: LoginScreen(),
            ));
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            print('login state : $state');
            print('login state : ${state.failure.message}');
            if(state.status == LoginStatus.error){
              ErrorDialog(e: state.failure);
              // showDialog(context: context,
              //  builder: (context) => AlertDialog(title: Text('Error'), content: Text('${state.failure.message}'))
              //  );
            }
          },
          builder: (context, state) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Instagram',
                              style: TextStyle(
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12.0),
                            TextFormField(
                              initialValue: "user01@gg.co",
                              decoration:
                                  const InputDecoration(hintText: 'Email'),
                              onChanged:(value) =>  context.read<LoginCubit>().emailChanged(value),
                              validator: (value) => !value!.contains('@')
                                  ? 'Please enter a valid email.'
                                  : null,
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              decoration:
                                  const InputDecoration(hintText: 'Password'),
                              onChanged: (value) => context.read<LoginCubit>().passwordChanged(value),
                              validator: (value) => value!.length < 6
                                  ? 'Must be at least 6 characters.'
                                  : null,
                            ),
                            const SizedBox(height: 28.0),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                onPrimary: Colors.white,
                                elevation: 1.0,
                                primary: Theme.of(context).primaryColor,
                              ),
                              onPressed: () => _submitForm(context, state.status == LoginStatus.submitting),
                              child: const Text('Log In'),
                            ),
                            const SizedBox(height: 12.0),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                onPrimary: Colors.grey[200],
                                elevation: 1.0,
                                primary: Colors.black,
                              ),
                              onPressed: () =>  Navigator.of(context)
                                  .pushNamed(SignupScreen.routeName),
                              child: const Text('No account? Sign up'),
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
      ),
    );
  }

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState!.validate() && !isSubmitting) {
      context.read<LoginCubit>().logInWithCredentials();
    }
  }

}
