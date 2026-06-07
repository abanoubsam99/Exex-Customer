import 'package:evex_user/core/ui/helpers/custom_loader.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/features/booking_services/booking_service_details/data/models/addition.dart';
import 'package:evex_user/features/booking_services/booking_service_details/data/models/addition_model.dart';
import 'package:evex_user/features/booking_services/booking_service_details/data/models/port_service.dart';
import 'package:evex_user/features/booking_services/booking_service_details/data/models/service_details_model.dart';
import 'package:evex_user/features/booking_services/booking_service_details/data/repos/port_services_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PortServicesController extends GetxController {
  final PortServicesRepo servicesRepo;
  PortServicesController(this.servicesRepo);

  Rx<List<PortService>> services = Rx<List<PortService>>([]);
  Rxn<PortService> selectedService = Rxn<PortService>();
  Future<void> getAllPortServices() async {
    services.value = [];
    startLoading();
    var res = await servicesRepo.getAllPortServices(3);
    stopLoading();
    res.fold(
      (l) {
        ToastManager.showSuccess(l.message);
      },
      (r) {
        services.value = r;
      },
    );
  }

  RxList<AdditionModel> addations = RxList<AdditionModel>([]);
  RxList<AdditionModel> selectedAddations = RxList<AdditionModel>([]);
  RxList<AdditionModel> buffets = RxList<AdditionModel>([]);
  RxList<AdditionModel> selectedBuffets = RxList<AdditionModel>([]);

  Future<void> getAddtions() async {
    addations.clear();
    buffets.clear();
    selectedAddations.clear();
    selectedBuffets.clear();
    startLoading();
    var res = await servicesRepo.getAdditions(3);
    stopLoading();
    res.fold(
      (l) {
        ToastManager.showSuccess(l.message);
      },
      (r) {
        for (var addation in r) {
          if (addation.specificToBuffet == true) {
            buffets.add(addation);
          } else {
            addations.add(addation);
          }
        }
      },
    );
  }

  Rxn<ServiceDetailsModel> serviceDetailsModel = Rxn<ServiceDetailsModel>();
  Future<void> getServicedata() async {
    startLoading();
    var res = await servicesRepo.getServiceData(selectedService.value!.id);
    stopLoading();
    res.fold(
      (l) {
        ToastManager.showError(l.message);
      },
      (r) {
        serviceDetailsModel.value = r;
        getTotalCost();
      },
    );
  }

  RxDouble totalCost = 0.0.obs;
  getTotalCost() {
    double cost = 0;
    for (var element in selectedAddations) {
      if (!(element.displayNumber ?? true) &&
          serviceDetailsModel.value!.oldGifts!.any(
            (e) => e.additionId == element.id,
          )) {
        continue;
      }
      cost += (element.count ?? 1) * (element.price ?? 1).toDouble();
    }
    for (var element in selectedBuffets) {
      if (!(element.displayNumber ?? true) &&
          serviceDetailsModel.value!.oldGifts!.any(
            (e) => e.additionId == element.id,
          )) {
        continue;
      }
      cost += (element.count ?? 1) * (element.price ?? 1).toDouble();
    }
    cost += serviceDetailsModel.value?.price ?? 0;
    totalCost.value = cost;
  }

  checkGift(int additionId) {
    bool b = false;
    if (serviceDetailsModel.value != null) {
      b =
          serviceDetailsModel.value?.oldGifts?.indexWhere(
            (element) => element.additionId == additionId,
          ) !=
          -1;
    }
    print('checkGift $b, additionId $additionId');
    return b;
  }

  checkSelection(int additionId) {
    bool b = false;
    if (selectedAddations.isNotEmpty) {
      b =
          selectedAddations.indexWhere((element) => element.id == additionId) !=
          -1;
    }

    if (selectedBuffets.isNotEmpty) {
      b =
          selectedBuffets.indexWhere((element) => element.id == additionId) !=
          -1;
    }

    return b;
  }

  /// Additions
  changeAdditionCount(AdditionModel additionModel, int count) {
    int i = selectedAddations.indexWhere((e) => e.id == additionModel.id);
    if (i == -1) {
      selectedAddations.add(additionModel..count = count);
    } else {
      selectedAddations[i].count = count;
    }
    selectedAddations.refresh();
    getTotalCost();
  }

  /// Buffets
  changeBuffetCount(AdditionModel additionModel, int count) {
    int i = selectedBuffets.indexWhere((e) => e.id == additionModel.id);
    if (i == -1) {
      selectedBuffets.add(additionModel..count = count);
    } else {
      selectedBuffets[i].count = count;
    }
    getTotalCost();
  }

  List<Addition> prepareFinalAdditions() {
    final giftIds =
        serviceDetailsModel.value?.oldGifts?.map((e) => e.id).toList() ?? [];

    List<Addition> finalAdditions = [];
    finalAdditions =
        [...selectedAddations, ...selectedBuffets]
            .where(
              (addition) =>
                  ((addition.count ?? 0) > 0 &&
                      addition.displayNumber == true) ||
                  (addition.displayNumber == false &&
                      !giftIds.contains(addition.id)),
            )
            .map(
              (e) => Addition(
                name: e.name,
                additionId: e.id,
                id: e.id,
                number: e.count,
              ),
            )
            .toList();

    for (var element in finalAdditions) {
      print(element.toJson());
    }
    return finalAdditions;
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getAllPortServices();
      await getAddtions();
    });
  }
}
