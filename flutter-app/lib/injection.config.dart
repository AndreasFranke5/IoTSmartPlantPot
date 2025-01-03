// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:google_sign_in/google_sign_in.dart' as _i116;
import 'package:injectable/injectable.dart' as _i526;
import 'package:smart_plant_pot/datasources/auth_datesrouce.dart' as _i1029;
import 'package:smart_plant_pot/injection.dart' as _i485;
import 'package:smart_plant_pot/presentation/common/auth/bloc/auth_cubit.dart'
    as _i812;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final externalLibraryInjectableModule = _$ExternalLibraryInjectableModule();
    gh.lazySingleton<_i361.Dio>(() => externalLibraryInjectableModule.dio);
    gh.lazySingleton<_i116.GoogleSignIn>(
        () => externalLibraryInjectableModule.googleSignIn);
    gh.singleton<_i1029.AuthDataSource>(
        () => _i1029.AuthDataSourceImpl(gh<_i361.Dio>()));
    gh.singleton<_i812.AuthCubit>(() => _i812.AuthCubit(
          gh<_i1029.AuthDataSource>(),
          gh<_i116.GoogleSignIn>(),
        ));
    return this;
  }
}

class _$ExternalLibraryInjectableModule
    extends _i485.ExternalLibraryInjectableModule {}
