// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i10;
import 'package:dor_companion/app_router.dart' as _i7;
import 'package:dor_companion/data/api/sensy_api.dart' as _i11;
import 'package:dor_companion/data/api/sensy_interceptor.dart' as _i9;
import 'package:dor_companion/data/models/languages.dart' as _i13;
import 'package:dor_companion/data/models/search_suggestions.dart' as _i8;
import 'package:dor_companion/data/models/user_account.dart' as _i5;
import 'package:dor_companion/data/models/user_interests.dart' as _i12;
import 'package:dor_companion/injection/injection.dart' as _i14;
import 'package:dor_companion/web_router.dart' as _i6;
import 'package:flutter_pretty_dio_logger/flutter_pretty_dio_logger.dart'
    as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i4;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final module = _$Module();
    gh.lazySingleton<_i3.PrettyDioLogger>(() => module.prettyDioLogger);
    await gh.factoryAsync<_i4.SharedPreferences>(
      () => module.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i5.UserAccount>(
        () => _i5.UserAccount(gh<_i4.SharedPreferences>()));
    gh.lazySingleton<_i6.WebRouter>(() => _i6.WebRouter(gh<_i5.UserAccount>()));
    gh.lazySingleton<_i7.AppRouter>(() => _i7.AppRouter(gh<_i5.UserAccount>()));
    gh.lazySingleton<_i8.SearchSuggestions>(
        () => _i8.SearchSuggestions(gh<_i4.SharedPreferences>()));
    gh.factory<_i9.SensyInterceptor>(
        () => _i9.SensyInterceptor(gh<_i5.UserAccount>()));
    gh.lazySingleton<_i10.Dio>(() => module.dio(
          gh<_i9.SensyInterceptor>(),
          gh<_i3.PrettyDioLogger>(),
        ));
    gh.lazySingleton<_i11.SensyApi>(() => _i11.SensyApi(gh<_i10.Dio>()));
    gh.lazySingleton<_i12.UserInterestsChangeNotifier>(
        () => _i12.UserInterestsChangeNotifier(gh<_i11.SensyApi>()));
    gh.lazySingleton<_i13.FavoriteLanguagesChangeNotifier>(
        () => _i13.FavoriteLanguagesChangeNotifier(gh<_i11.SensyApi>()));
    return this;
  }
}

class _$Module extends _i14.Module {}
