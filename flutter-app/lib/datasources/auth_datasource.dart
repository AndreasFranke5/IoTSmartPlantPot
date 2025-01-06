import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_plant_pot/datasources/datasources.dart';
import 'package:smart_plant_pot/models/user.dart' as models;

abstract class AuthDataSource {
  Future<Either<String, models.User>> loginWithEmail(String email, String password);

  Future<Either<String, models.User>> loginWithGoogle();

  Future<Either<String, Unit>> signUpWithEmail(String email, String password, String name);

  Future<Either<String, Unit>> logout();
}

@Singleton(as: AuthDataSource)
class AuthDataSourceImpl implements AuthDataSource {
  final GoogleSignIn _googleSignIn;
  final UserDataSource _userDataSource;
  final Dio _httpClient;
  final SharedPreferences _prefs;

  const AuthDataSourceImpl(this._googleSignIn, this._userDataSource, this._httpClient, this._prefs);

  @override
  Future<Either<String, models.User>> loginWithEmail(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        await _cacheIdToken(credential);
        return await _userDataSource.getUser(credential.user!.uid);
      }
      return left('An error occurred');
    } catch (error) {
      return left(error.toString());
    }
  }

  @override
  Future<Either<String, models.User>> loginWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      final googleUser = await _googleSignIn.signIn();

      final googleAuth = await googleUser?.authentication;

      if (googleAuth?.idToken == null || googleAuth?.accessToken == null) {
        return left('Google Sign In Failed');
      }
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final firebaseCred = await FirebaseAuth.instance.signInWithCredential(credential);

      final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

      if (idToken == null) {
        return left('Google Sign In Failed');
      }

      await _cacheIdToken(firebaseCred);

      // login user with google
      await _httpClient.post('/loginWithGoogle', data: {'idToken': idToken});
      // get user data and return
      return await _userDataSource.getUser(idToken);
    } catch (error) {
      return left(error.toString());
    }
  }

  @override
  Future<Either<String, Unit>> signUpWithEmail(String email, String password, String name) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) return right(unit);

      return left('An error occurred');
    } on FirebaseAuthException catch (e) {
      String error = 'An error occurred';
      if (e.code == 'weak-password') {
        error = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        error = 'The account already exists for that email.';
      }
      return left(error);
    } catch (error) {
      return left(error.toString());
    }
  }

  @override
  Future<Either<String, Unit>> logout() async {
    try {
      await Future.wait([
        _googleSignIn.signOut(),
        FirebaseAuth.instance.signOut(),
        _prefs.remove('idToken'),
      ]);
      return right(unit);
    } catch (error) {
      return left(error.toString());
    }
  }

  Future<void> _cacheIdToken(UserCredential credential) async {
    final idToken = await credential.user!.getIdToken();
    if (idToken != null) _prefs.setString('idToken', idToken);
  }
}
