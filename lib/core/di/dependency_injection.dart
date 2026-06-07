import 'package:dio/dio.dart';
import 'package:evex_user/core/helpers/cash_helper.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../networking/dio_factory.dart';
import '../services/token_service.dart';

class DependencyCreator {
  static init() async {
    /// External
    final sharedPreferences = await SharedPreferences.getInstance();
    Get.lazyPut(() => sharedPreferences, fenix: true);

    /// Core
    Get.lazyPut(() => CashHelper(Get.find()), fenix: true);
    Get.lazyPut(() => TokenService(Get.find()), fenix: true);
    Dio dio = DioFactory.getDio();
    Get.lazyPut(() => dio, fenix: true);
  }
}

// Future<void> setupGetIt() async {
//   /// External
//   final sharedPreferences = await SharedPreferences.getInstance();
//   getIt.registerLazySingleton(() => sharedPreferences);

//   /// Core
//   getIt.registerLazySingleton(() => CashHelper(getIt()));
//   getIt.registerLazySingleton(() => TokenService(getIt()));
//   Dio dio = DioFactory.getDio();
//   getIt.registerLazySingleton(() => dio);

//   ///login
//   getIt.registerFactory(() => LoginCubit(getIt()));
//   getIt.registerLazySingleton(() => LoginRepo(getIt()));
//   getIt.registerLazySingleton(() => LoginRemoteDataSource(getIt()));

//   ///posts
//   getIt.registerFactory(() => PostCubit(getIt()));
//   getIt.registerLazySingleton(() => PostRepo(postRemoteDataSource: getIt()));
//   getIt.registerLazySingleton(() => PostRemoteDataSource(getIt()));
// }
