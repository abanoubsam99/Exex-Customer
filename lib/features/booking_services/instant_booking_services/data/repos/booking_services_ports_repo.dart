import 'package:dartz/dartz.dart';
import 'package:evex_user/data/models/error_model.dart';
import 'package:evex_user/features/booking_services/instant_booking_services/data/datasources/booking_servicies_ports_remote_data_source.dart';
import 'package:evex_user/data/models/get_ports_request.dart';
import 'package:evex_user/data/models/ports_respond_model.dart';

import '../../../../../../../core/networking/api_error_handler.dart';

class BookingServicesPortsRepo {
  BookingServicesPortsRepo(this.bookingServiciesPortsRemoteDataSource);
  final BookingServiciesPortsRemoteDataSource
  bookingServiciesPortsRemoteDataSource;

  Future<Either<ErrorModel, PortsRespondModel>> getAllPortServices(
    GetPortsRequest queries,
  ) async {
    try {
      var result = await bookingServiciesPortsRemoteDataSource.getPorts(
        queries.toJson(),
      );
      return Right(result);
    } catch (error) {
      return Left(ErrorHandler.handle(error).apiErrorModel);
    }
  }

}
