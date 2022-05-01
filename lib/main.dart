import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_bloc/blocs/auth/auth_bloc.dart';
import 'package:instagram_bloc/blocs/simple_bloc_observer.dart';
import 'package:instagram_bloc/config/custom_routes.dart';


import 'package:firebase_core/firebase_core.dart';
import 'package:instagram_bloc/repositories/auth_repository.dart';
import 'package:instagram_bloc/screens/login_screen.dart';
import 'package:instagram_bloc/screens/splash.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  BlocOverrides.runZoned(
    () {},
    blocObserver: AppBlocObserver(),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // context.read<AuthRepository>();
    return  MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (_) => AuthRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) =>
                AuthBloc(authRepository: context.read<AuthRepository>()),
          ),
        ],
        child: MaterialApp(
            title: 'Instagram Bloc',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: Colors.grey[50],
              appBarTheme: const AppBarTheme(
                systemOverlayStyle: SystemUiOverlayStyle.light,
                color: Colors.white,
                iconTheme: IconThemeData(color: Colors.black),
                toolbarTextStyle: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
            onGenerateRoute: CustomRouter.onGenerateRoute,
            initialRoute: SplashScreen.routeName,
            // initialRoute: LoginScreen.routeName,
          ),
      ),
    );
  }
}






// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);
//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
           
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: (){},
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//    Widget buildValue(int value, BuildContext context) {
//     return Text(
//       value.toString(),
//       style: Theme.of(context).textTheme.headline4,
//     );
//   }
// }
