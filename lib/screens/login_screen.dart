import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
   static const String routeName = '/login';
  static Route route(){
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (_,__,___) => const LoginScreen());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Login')),
    );
  }
}