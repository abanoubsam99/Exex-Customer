import 'package:evex_user/core/location/data/datasource/location_remote_datasource.dart';
import 'package:evex_user/core/location/data/repo/location_repo.dart';
import 'package:evex_user/features/profile/data/repos/profile_repo.dart';
import 'package:evex_user/features/profile/data_sources/profile_remote_data_source.dart';
import 'package:evex_user/features/profile/logic/profile_controller.dart';
import 'package:get/get.dart';

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSource(Get.find()),
    );
    Get.lazyPut<LocationRemoteDataSource>(
      () => LocationRemoteDataSource(Get.find()),
    );
    Get.lazyPut<ProfileRepo>(() => ProfileRepo(Get.find()));
    Get.lazyPut<LocationRepo>(() => LocationRepo(Get.find()));
    Get.lazyPut<ProfileController>(
      () => ProfileController(Get.find(), Get.find()),
    );
  }
}
