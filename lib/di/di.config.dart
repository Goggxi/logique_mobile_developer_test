// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:http/http.dart' as _i3;
import 'package:injectable/injectable.dart' as _i2;
import 'package:logique_mobile_developer_test/di/modules.dart' as _i8;
import 'package:logique_mobile_developer_test/repositories/post_repository.dart'
    as _i5;
import 'package:logique_mobile_developer_test/repositories/user_repository.dart'
    as _i7;
import 'package:logique_mobile_developer_test/utils/http_client.dart' as _i4;
import 'package:logique_mobile_developer_test/utils/utils.dart' as _i6;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.singleton<_i3.Client>(registerModule.httpClient);
    gh.factory<_i4.HttpClient>(() => _i4.HttpClient(gh<_i3.Client>()));
    gh.lazySingleton<_i5.PostRepository>(
        () => _i5.PostRepositoryImpl(gh<_i6.HttpClient>()));
    gh.lazySingleton<_i7.UserRepository>(
        () => _i7.UserRepositoryImpl(gh<_i6.HttpClient>()));
    return this;
  }
}

class _$RegisterModule extends _i8.RegisterModule {}
