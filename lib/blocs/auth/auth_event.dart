
part of 'auth_bloc.dart';

class AuthEvent extends Equatable {
 
  @override
  List<Object?> get props => [];
}

class AuthUserChanged extends AuthEvent {
   final auth.User? user;
   AuthUserChanged({this.user});

  @override
  List<Object?> get props => [user];
}

class AuthLogoutRequested extends AuthEvent{}