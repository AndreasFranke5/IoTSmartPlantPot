part of 'auth_cubit.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthInitial;

  const factory AuthState.authenticated(User user) = Authenticated;

  const factory AuthState.accountCreated() = AuthAccountCreated;

  const factory AuthState.failed(String error) = AuthFailure;

  const factory AuthState.processing() = AuthProcessing;
}
