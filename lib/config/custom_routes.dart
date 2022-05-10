import 'package:flutter/material.dart';
import 'package:instagram_bloc/screens/comments/comments_screen.dart';
import 'package:instagram_bloc/screens/edit_profile/edit_profile_screen.dart';
import 'package:instagram_bloc/screens/login_screen.dart';
import 'package:instagram_bloc/screens/nav/nav_screen.dart';
import 'package:instagram_bloc/screens/profile/profile_screen.dart';
import 'package:instagram_bloc/screens/signup_screen.dart';
import 'package:instagram_bloc/screens/splash.dart';

class CustomRouter{
  static Route onGenerateRoute(RouteSettings settings){
    print(settings.name);
    switch (settings.name){
      case '/':
        return MaterialPageRoute(settings: const RouteSettings(name: '/'),
        builder: (_) => const Scaffold(),
        );
      case SplashScreen.routeName:
        return SplashScreen.route();
      case LoginScreen.routeName:
        return LoginScreen.route();
      case NavScreen.routeName:
        return NavScreen.route();
      case SignupScreen.routeName:
        return SignupScreen.route();
      
      
        default:  
        return _errorRoute();
    }  
  }

  static Route onGenerateNestedRoute(RouteSettings settings) {
    print('Nested Route: ${settings.name}');
    switch (settings.name) {
      case ProfileScreen.routeName:
        return ProfileScreen.route(args: settings.arguments as ProfileScreenArgs);
      case EditProfileScreen.routeName:
        return EditProfileScreen.route(args: settings.arguments  as EditProfileScreenArgs);
      case CommentsScreen.routeName:
        return CommentsScreen.route(args: settings.arguments as CommentsScreenArgs);
      default:
        return _errorRoute();
    }
  }


  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'), 
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error Page'),),
        body: const Center(child: Text('Something went wrong'),),
      ),
    );
  }
}

