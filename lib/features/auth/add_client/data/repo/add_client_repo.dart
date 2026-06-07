import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:evex_user/core/models/error_model.dart';
import 'package:evex_user/core/networking/api_error_handler.dart';
import 'package:evex_user/features/auth/add_client/data/datasources/add_client_remote_datasource.dart';
import 'package:evex_user/features/auth/add_client/data/model/add_client_response.dart';

class AddClientRepo {
  final AddClientRemoteDataSource addClientRemoteDataSource;
  AddClientRepo(this.addClientRemoteDataSource);

  Future<Either<ErrorModel, AddClientResponse>> addClient({
    required String name,
    required String governorate,
    required String city,
  }) async {
    try {
      var response = await addClientRemoteDataSource.addClient(
        FormData.fromMap({
          'name': name,
          'governorate': governorate,
          'city': city,
        }),
      );

      return Right(response);
    } catch (error) {
      return Left(ErrorHandler.handle(error).apiErrorModel);
    }
  }
}
