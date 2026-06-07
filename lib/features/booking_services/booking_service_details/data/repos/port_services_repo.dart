import 'package:dartz/dartz.dart';
import 'package:evex_user/data/models/error_model.dart';
import 'package:evex_user/features/booking_services/booking_service_details/data/datasources/port_services_remote_data_source.dart';
import 'package:evex_user/data/models/addition_model.dart';
import 'package:evex_user/data/models/port_service.dart';
import 'package:evex_user/data/models/service_details_model.dart';

import '../../../../../../../core/networking/api_error_handler.dart';

class PortServicesRepo {
  PortServicesRepo(this.portServicesRemoteDataSource);
  final PortServicesRemoteDataSource portServicesRemoteDataSource;

  Future<Either<ErrorModel, List<PortService>>> getAllPortServices(
    int portId,
  ) async {
    try {
      var result = await portServicesRemoteDataSource.getAllPortServices(
        portId,
      );
      return Right(result);
    } catch (error) {
      return Left(ErrorHandler.handle(error).apiErrorModel);
    }
  }

  Future<Either<ErrorModel, List<AdditionModel>>> getAdditions(
    int portId,
  ) async {
    try {
      var result = await portServicesRemoteDataSource.getAllAdditions(portId);
      return Right(result);
    } catch (error) {
      return Left(ErrorHandler.handle(error).apiErrorModel);
    }
  }

  Future<Either<ErrorModel, ServiceDetailsModel>> getServiceData(int id) async {
    try {
      var result = await portServicesRemoteDataSource.getServiceData(id);
      return Right(result);
    } catch (error) {
      return Left(ErrorHandler.handle(error).apiErrorModel);
    }
  }
}
