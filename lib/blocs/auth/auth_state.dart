part of 'auth_bloc.dart';

enum AuthStatus {unknown, authenticated, unauthenticated}

class AuthState extends Equatable {
  final auth.User? user;
  final AuthStatus status;
  const AuthState({ this.user, this.status = AuthStatus.unknown});
  
  factory AuthState.unknown() => const AuthState();

  factory AuthState.authenticated({required auth.User user}){
    return AuthState(user: user, status: AuthStatus.authenticated);
  }

  factory AuthState.unauthenticated(){
    return const AuthState(status: AuthStatus.unauthenticated);
  }

  @override
  List<Object?> get props => [user, status];

  AuthState copyWith({
    auth.User? user,
    AuthStatus? status,
  }) {
    return AuthState(
      user: user ?? this.user,
      status: status ?? this.status,
    );
  }

  @override
  String toString() => 'AuthState(user: $user, status: $status)';
}

