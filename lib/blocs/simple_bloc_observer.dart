import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    print(event);
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);
    super.onTransition(bloc, transition);
  }

  @override
  Future<void> onError(BlocBase cubit, Object error, StackTrace stackTrace) async {
    print(error);
    super.onError(cubit, error, stackTrace);
  }

  @override
 void onChange(BlocBase bloc, Change change) {
   super.onChange(bloc, change);
   print('On Change Bloc run time Type ${bloc.runtimeType} and change $change');
 }
}


