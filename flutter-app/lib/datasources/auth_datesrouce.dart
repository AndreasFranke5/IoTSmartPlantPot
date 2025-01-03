import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:smart_plant_pot/logger.dart';
import 'package:smart_plant_pot/models/user.dart';

abstract class AuthDataSource {
  Future<Either<String, User>> getUser(String id);
}

@Singleton(as: AuthDataSource)
class AuthDataSourceImpl implements AuthDataSource {
  final Dio _httpClient;

  const AuthDataSourceImpl(this._httpClient);

  @override
  Future<Either<String, User>> getUser(String id) async {
    try {
      final response = await _httpClient.get('/user', queryParameters: {'userId': id});
      final user = User.fromJson(response.data);
      return right(user);
    } catch (e) {
      logger.e(e);
      return left(e.toString());
    }
  }
}
