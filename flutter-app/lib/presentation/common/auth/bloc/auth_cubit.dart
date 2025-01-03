import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:smart_plant_pot/datasources/auth_datesrouce.dart';
import 'package:smart_plant_pot/logger.dart';
import 'package:smart_plant_pot/models/models.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

part 'auth_state.dart';

part 'auth_cubit.freezed.dart';

@singleton
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authDataSource, this.googleSignIn) : super(const AuthState.initial()) {
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) async {
      // if (account != null) {
      //   final canAccessScopes = await _googleSignIn.canAccessScopes(scopes);
      //   print('Can access scopes: $canAccessScopes');
      // }
      logger.d(account);
      if (account != null) {
        final res = await _authDataSource.getUser(account.id);
        res.fold(
          (error) => emit(AuthState.failed(error)),
          (user) => emit(AuthState.authenticated(user)),
        );
      }
    }).onError((error) {
      logger.e(error);
      emit(AuthState.failed(error.toString()));
    });
  }

  final AuthDataSource _authDataSource;
  final GoogleSignIn googleSignIn;

  void loginWithGoogle() async {
    emit(const AuthState.processing());

    try {
      await googleSignIn.signOut();
      await googleSignIn.signIn();
    } catch (error) {
      emit(AuthState.failed(error.toString()));
    }
  }

  void login(String email, String password) async {
    emit(const AuthState.processing());

    try {
      final credential = await firebase_auth.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        final res = await _authDataSource.getUser(credential.user!.uid);
        res.fold(
          (error) => emit(AuthState.failed(error)),
          (user) => emit(AuthState.authenticated(user)),
        );
      }
    } catch (error) {
      emit(AuthState.failed(error.toString()));
    }
  }

  void signUp(String email, String password, String name) async {
    emit(const AuthState.processing());

    try {
      final credential = await firebase_auth.FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) emit(const AuthState.accountCreated());
    } on firebase_auth.FirebaseAuthException catch (e) {
      String error = 'An error occurred';
      if (e.code == 'weak-password') {
        error = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        error = 'The account already exists for that email.';
      }
      emit(AuthState.failed(error));
    } catch (error) {
      emit(AuthState.failed(error.toString()));
    }
  }
}
