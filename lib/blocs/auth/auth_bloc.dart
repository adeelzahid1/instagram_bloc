import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:equatable/equatable.dart';
import 'package:instagram_bloc/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  late final StreamSubscription userSubscription;
  late AuthRepository authRepository;

  // late final StreamSubscription<auth.User?> _userSubscription;

  AuthBloc({required this.authRepository}): super(AuthState.unknown()) {
   userSubscription = authRepository.user.listen((auth.User? user) => add(AuthUserChanged(user: user)));

  on<AuthUserChanged>((event, emit) {
      if (event.user != null) {
        emit(
            state.copyWith(status: AuthStatus.authenticated, user: event.user));
      } else {
        emit(state.copyWith(status: AuthStatus.unauthenticated, user: null));
      }
    });

    on<AuthLogoutRequested>((event, emit) async {
      await authRepository.logOut();
    });


  }

  //   @override
  // Stream<AuthState> mapEventToState(AuthEvent event) async* {
  //   if (event is AuthUserChanged) {
  //     yield* _mapAuthUserChangedToState(event);
  //   } else if (event is AuthLogoutRequested) {
  //     await _authRepository.logOut();
  //   }
  // }

  // Stream<AuthState> _mapAuthUserChangedToState(AuthUserChanged event) async* {
  //   yield event.user != null
  //       ? AuthState.authenticated(user: event.user)
  //       : AuthState.unauthenticated();
  // }


  @override
  Future<void> close(){
    userSubscription.cancel();
    return super.close();
  }
  
}
