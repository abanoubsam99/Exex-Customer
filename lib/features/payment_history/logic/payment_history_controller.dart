import 'package:evex_user/core/location/data/models/city.dart';
import 'package:evex_user/core/location/data/models/governate.dart';
import 'package:evex_user/core/location/data/repo/location_repo.dart';
import 'package:evex_user/core/models/user_model.dart';
import 'package:evex_user/core/routing/routes.dart';
import 'package:evex_user/core/services/user_service.dart';
import 'package:evex_user/core/ui/helpers/custom_loader.dart';
import 'package:evex_user/core/ui/helpers/toast_manager.dart';
import 'package:evex_user/features/auth/add_client/data/repo/add_client_repo.dart';
import 'package:evex_user/features/payment_history/data/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class PaymentHistoryController extends GetxController {
  // AddClientRepo addClientRepo;
  // LocationRepo locationRepo;

  RxBool isLoading = false.obs;
    
Rxn<List<TransactionModel>> transactions = Rxn<List<TransactionModel>>();
  

  //addClient
  // addClient() async {
  //   if (nameController.text.trim().isEmpty) {
  //     ToastManager.showError('الرجاء ادخال اسم العميل');
  //     return;
  //   } else if (selectedgovernnorate.value == null) {
  //     ToastManager.showError('الرجاء اختيار المحافظة');
  //     return;
  //   } else if (selectedCity.value == null) {
  //     ToastManager.showError('الرجاء اختيار المدينة');
  //     return;
  //   }

  //   startLoading();
  //   var result = await addClientRepo.addClient(
  //     name: nameController.text.trim(),
  //     governorate: selectedgovernnorate.value!.governorateNameAr,
  //     city: selectedCity.value!.cityNameAr,
  //   );
  //   stopLoading();
  //   result.fold(
  //     (l) {
  //       ToastManager.showError(l.message);
  //     },
  //     (r) async {
  //       ToastManager.showSuccess(r.message);
  //       //save userdata in shared pref after update phone
  //       UserModel? user = UserService.to.currentUser.value;
  //       if (user != null) {
  //         user.modelId = r.modelId;
  //         UserService.to.saveUser(user);
  //       }
  //       Get.offAllNamed(Routes.mainScreen);
  //     },
  //   );
  // }

  @override
  void onInit() {
    transactions.value = myTransactions;
    super.onInit();
  }
}
