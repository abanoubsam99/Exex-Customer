// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:evex_user/core/models/error_model.dart';
import 'package:evex_user/features/home/data/data_sources/home_remote_data_source.dart';
import 'package:evex_user/features/home/data/models/port_category_with_port_types.dart';
import 'package:evex_user/features/home/data/models/special_offer.dart';

import '../../../../core/networking/api_error_handler.dart';

class HomeRepo {
  final HomeRemoteDataSource homeRemoteDataSource;
  HomeRepo(this.homeRemoteDataSource);

  Future<Either<ErrorModel, List<PortCategoryWithPortTypes>>>
  getHomeUserAppInfo({String? gov, String? city}) async {
    try {
      var result = await homeRemoteDataSource.getHomeUserAppInfo({
        'gov': gov,
        'city': city,
      });
      return Right(result);
    } catch (error) {
      return Left(ErrorHandler.handle(error).apiErrorModel);
    }
  }

  Future<Either<ErrorModel, List<SpecialOffer>>> getSpecialOffers() async {
    try {
      var result = await homeRemoteDataSource.getSpecialOffers();
      return Right(result);
    } catch (error) {
      return Left(ErrorHandler.handle(error).apiErrorModel);
    }
  }
}
