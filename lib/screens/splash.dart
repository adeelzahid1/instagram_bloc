import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_bloc/blocs/auth/auth_bloc.dart';
import 'package:instagram_bloc/screens/login_screen.dart';
import 'package:instagram_bloc/screens/nav/nav_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const String routeName = '/splash';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const SplashScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          print('Print State from splash $state');
          if(state.status == AuthStatus.unauthenticated){
            Navigator.of(context).pushNamed(LoginScreen.routeName);
            //Go to the Login Screen
          }
          else if(state.status == AuthStatus.authenticated){
            print('User is Authenticated , go to next route');
            Navigator.of(context).pushNamed(NavScreen.routeName);
            // Go to Home page .. 
          }
        },
        child: const Scaffold(
          body: Center(child: Text('Splash')),
        ),
      ),
    );
  }
}
