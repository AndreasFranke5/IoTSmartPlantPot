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
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:smart_plant_pot/datasources/auth_datasource.dart' as _i311;
import 'package:smart_plant_pot/datasources/datasources.dart' as _i1020;
import 'package:smart_plant_pot/datasources/plant_datasource.dart' as _i260;
import 'package:smart_plant_pot/datasources/user_datasource.dart' as _i1039;
import 'package:smart_plant_pot/injection.dart' as _i485;
import 'package:smart_plant_pot/presentation/common/auth/bloc/auth_cubit.dart'
    as _i812;
import 'package:smart_plant_pot/presentation/home/bloc/add_device_cubit.dart'
    as _i286;
import 'package:smart_plant_pot/presentation/home/bloc/add_plant_cubit.dart'
    as _i647;
import 'package:smart_plant_pot/presentation/home/bloc/home_cubit.dart'
    as _i282;
import 'package:smart_plant_pot/presentation/plant_details/bloc/plant_details_cubit.dart'
    as _i668;
import 'package:smart_plant_pot/presentation/plant_details/bloc/plant_details_data_cubit.dart'
    as _i601;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final externalLibraryInjectableModule = _$ExternalLibraryInjectableModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => externalLibraryInjectableModule.prefs,
      preResolve: true,
    );
    gh.factory<_i601.PlantDetailsDataCubit>(
        () => _i601.PlantDetailsDataCubit());
    gh.lazySingleton<_i361.Dio>(() => externalLibraryInjectableModule.dio);
    gh.lazySingleton<_i116.GoogleSignIn>(
        () => externalLibraryInjectableModule.googleSignIn);
    gh.singleton<_i1039.UserDataSource>(() => _i1039.UserDataSourceImpl(
          gh<_i361.Dio>(),
          gh<_i460.SharedPreferences>(),
        ));
    gh.singleton<_i260.PlantDataSource>(() => _i260.PlantDataSourceImpl(
          gh<_i361.Dio>(),
          gh<_i460.SharedPreferences>(),
        ));
    gh.factory<_i282.HomeCubit>(() => _i282.HomeCubit(
          gh<_i1020.UserDataSource>(),
          gh<_i1020.PlantDataSource>(),
        ));
    gh.singleton<_i311.AuthDataSource>(() => _i311.AuthDataSourceImpl(
          gh<_i116.GoogleSignIn>(),
          gh<_i1020.UserDataSource>(),
          gh<_i361.Dio>(),
          gh<_i460.SharedPreferences>(),
        ));
    gh.factory<_i647.AddPlantCubit>(
        () => _i647.AddPlantCubit(gh<_i1020.UserDataSource>()));
    gh.factory<_i286.AddDeviceCubit>(
        () => _i286.AddDeviceCubit(gh<_i1020.UserDataSource>()));
    gh.singleton<_i812.AuthCubit>(
        () => _i812.AuthCubit(gh<_i1020.AuthDataSource>()));
    gh.factory<_i668.PlantDetailsCubit>(
        () => _i668.PlantDetailsCubit(gh<_i1020.PlantDataSource>()));
    return this;
  }
}

class _$ExternalLibraryInjectableModule
    extends _i485.ExternalLibraryInjectableModule {}
