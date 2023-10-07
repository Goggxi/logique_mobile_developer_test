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
import 'package:logique_mobile_developer_test/di/modules.dart' as _i13;
import 'package:logique_mobile_developer_test/presentaions/blocs/post/post_bloc.dart'
    as _i11;
import 'package:logique_mobile_developer_test/presentaions/blocs/user/user_bloc.dart'
    as _i12;
import 'package:logique_mobile_developer_test/presentaions/cubits/saved_posts/saved_posts_cubit.dart'
    as _i8;
import 'package:logique_mobile_developer_test/repositories/post_repository.dart'
    as _i6;
import 'package:logique_mobile_developer_test/repositories/repository.dart'
    as _i9;
import 'package:logique_mobile_developer_test/repositories/user_repository.dart'
    as _i10;
import 'package:logique_mobile_developer_test/utils/database_helper.dart'
    as _i4;
import 'package:logique_mobile_developer_test/utils/http_client.dart' as _i5;
import 'package:logique_mobile_developer_test/utils/utils.dart' as _i7;

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
    gh.lazySingleton<_i4.DatabaseHelper>(() => _i4.DatabaseHelper());
    gh.factory<_i5.HttpClient>(() => _i5.HttpClient(gh<_i3.Client>()));
    gh.lazySingleton<_i6.PostRepository>(() => _i6.PostRepositoryImpl(
          gh<_i7.HttpClient>(),
          gh<_i7.DatabaseHelper>(),
        ));
    gh.lazySingleton<_i8.SavedPostsCubit>(
        () => _i8.SavedPostsCubit(gh<_i9.PostRepository>()));
    gh.lazySingleton<_i10.UserRepository>(
        () => _i10.UserRepositoryImpl(gh<_i7.HttpClient>()));
    gh.factory<_i11.PostBloc>(() => _i11.PostBloc(gh<_i9.PostRepository>()));
    gh.factory<_i12.UserBloc>(() => _i12.UserBloc(gh<_i9.UserRepository>()));
    return this;
  }
}

class _$RegisterModule extends _i13.RegisterModule {}
