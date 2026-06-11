import 'package:evex_user/data/models/ports_respond_model.dart';
import 'package:evex_user/data/repos/port_services_repo.dart';
import 'package:evex_user/data/repos/wallet_repo.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'direct_service_details_state.dart';

/// تفاصيل خدمة الدفع المباشر: منتجات/خدمات التاجر + نقاط العميل (من المحفظة).
class DirectServiceDetailsCubit extends Cubit<DirectServiceDetailsState> {
  final PortServicesRepo _servicesRepo;
  final WalletRepo _walletRepo;

  /// البوابة المختارة من القائمة السابقة (بتغذّي الهيدر + بياناتها للتواصل).
  final Item? port;

  DirectServiceDetailsCubit(
    this._servicesRepo,
    this._walletRepo, {
    this.port,
  }) : super(const DirectServiceDetailsState()) {
    WidgetsBinding.instance.addPostFrameCallback((_) => loadData());
  }

  Future<void> loadData() async {
    emit(state.copyWith(isLoading: true));
    final services = await _servicesRepo.getAllPortServices(port?.id ?? 0);
    final wallet = await _walletRepo.getWalletData();
    emit(state.copyWith(
      isLoading: false,
      services: services ?? const [],
      wallet: wallet,
    ));
  }
}
