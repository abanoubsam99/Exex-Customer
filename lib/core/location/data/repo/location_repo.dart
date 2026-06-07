import 'package:dartz/dartz.dart';
import 'package:evex_user/core/location/data/datasource/location_remote_datasource.dart';
import 'package:evex_user/core/location/data/models/city.dart';
import 'package:evex_user/core/location/data/models/governate.dart';
import 'package:evex_user/core/models/error_model.dart';
import 'package:evex_user/core/networking/api_error_handler.dart';

class LocationRepo {
  final LocationRemoteDataSource locationRemoteDataSource;
  LocationRepo(this.locationRemoteDataSource);

  Future<Either<ErrorModel, List<Governate>>> getGovernorates() async {
    try {
      var response = await locationRemoteDataSource.getGovernorates();
      return Right(response);
    } catch (error) {
      return Left(ErrorHandler.handle(error).apiErrorModel);
    }
  }

  Future<Either<ErrorModel, List<City>>> getCities(int govId) async {
    try {
      var response = await locationRemoteDataSource.getCities(govId);
      return Right(response);
    } catch (error) {
      return Left(ErrorHandler.handle(error).apiErrorModel);
    }
  }
}
