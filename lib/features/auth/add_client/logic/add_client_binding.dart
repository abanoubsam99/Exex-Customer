import 'package:evex_user/core/location/data/datasource/location_remote_datasource.dart';
import 'package:evex_user/core/location/data/repo/location_repo.dart';
import 'package:evex_user/features/auth/add_client/data/datasources/add_client_remote_datasource.dart';
import 'package:evex_user/features/auth/add_client/data/repo/add_client_repo.dart';
import 'package:evex_user/features/auth/add_client/logic/add_client_controller.dart';
import 'package:get/get.dart';


class AddClientBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocationRemoteDataSource>(
      () => LocationRemoteDataSource(Get.find()),
    );
    Get.lazyPut<AddClientRemoteDataSource>(
      () => AddClientRemoteDataSource(Get.find()),
    );
    Get.lazyPut<LocationRepo>(() => LocationRepo(Get.find()));
    Get.lazyPut<AddClientRepo>(() => AddClientRepo(Get.find()));

    Get.lazyPut<AddClientController>(
      () => AddClientController(Get.find(), Get.find()),
    );
  }
}
