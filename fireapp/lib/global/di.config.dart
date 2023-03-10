// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i4;
import 'package:fireapp/data/client/api/rest_client.dart' as _i5;
import 'package:fireapp/data/client/authentication_client.dart' as _i6;
import 'package:fireapp/data/persistence/authentication_persistence.dart'
    as _i3;
import 'package:fireapp/domain/repository/authentication_repository.dart'
    as _i7;
import 'package:fireapp/presentation/login/login_view_model.dart' as _i8;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../data/client/api/api_di.dart' as _i9;

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// initializes the registration of main-scope dependencies inside of GetIt
_i1.GetIt init(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final aPIDependencyInjection = _$APIDependencyInjection();
  gh.singleton<_i3.AuthenticationPersistence>(_i3.AuthenticationPersistence());
  gh.singleton<_i4.Dio>(aPIDependencyInjection.dio);
  gh.singleton<_i5.RestClient>(
      aPIDependencyInjection.createRestClient(gh<_i4.Dio>()));
  gh.factory<_i6.AuthenticationClient>(
      () => _i6.AuthenticationClient(gh<_i5.RestClient>()));
  gh.factory<_i7.AuthenticationRepository>(() => _i7.AuthenticationRepository(
        gh<_i6.AuthenticationClient>(),
        gh<_i3.AuthenticationPersistence>(),
      ));
  gh.factory<_i8.LoginViewModel>(
      () => _i8.LoginViewModel(gh<_i7.AuthenticationRepository>()));
  return getIt;
}

class _$APIDependencyInjection extends _i9.APIDependencyInjection {}
