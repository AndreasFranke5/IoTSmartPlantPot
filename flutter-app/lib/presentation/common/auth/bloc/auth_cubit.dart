import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:smart_plant_pot/datasources/datasources.dart';
import 'package:smart_plant_pot/logger.dart';
import 'package:smart_plant_pot/models/models.dart';

part 'auth_state.dart';

part 'auth_cubit.freezed.dart';

@singleton
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authDataSource, this._notificationsDataSource) : super(const AuthState.initial());

  final AuthDataSource _authDataSource;
  final NotificationsDataSource _notificationsDataSource;

  Future<void> loginWithGoogle() async {
    emit(const AuthState.processing());

    try {
      final res = await _authDataSource.loginWithGoogle();
      res.fold(
        (error) => emit(AuthState.failed(error)),
        (user) => emit(AuthState.authenticated(user)),
      );
    } catch (error) {
      emit(AuthState.failed(error.toString()));
    }
  }

  Future<void> login(String email, String password) async {
    emit(const AuthState.processing());

    final res = await _authDataSource.loginWithEmail(email, password);
    res.fold(
      (error) => emit(AuthState.failed(error)),
      (user) => emit(AuthState.authenticated(user)),
    );
  }

  Future<void> signUp(String email, String password, String name) async {
    emit(const AuthState.processing());

    final res = await _authDataSource.signUpWithEmail(email, password, name);
    res.fold(
      (error) => emit(AuthState.failed(error)),
      (_) => emit(const AuthState.accountCreated()),
    );
  }

  Future<void> logout() async {
    emit(const AuthState.processing());

    final res = await _authDataSource.logout();
    res.fold(
      (error) => emit(AuthState.failed(error)),
      (_) => emit(const AuthState.initial()),
    );
  }

  void activateNotificationToken() => _notificationsDataSource
    ..activateNotificationToken()
    ..notificationListener();
}
