import 'dart:developer';
import 'dart:io';

import 'package:evex/components/custom_loader.dart';
import 'package:evex/components/toast_manager.dart';
import 'package:evex/feature/vendor/add_get_way/data/repo/getway_image_services_repo.dart';
import 'package:evex/feature/vendor/services/add_offer/data/repo/image_services_repo.dart';
import 'package:evex/feature/vendor/services/home_services/logic/controller/services_controller.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class AddGetWayImageControler extends GetxController {
  List<String> imageUrls = [];
  bool isLoading = false;
  RxList<dio.MultipartFile> selectedImages =
      <dio.MultipartFile>[].obs; // RxList
  RxBool picked = false.obs;
  bool isError = false;
  int? portId;

  AddGetWayImageRepo addImageRepo = AddGetWayImageRepo();
  RxList<String> images = <String>[].obs;
  Future<void> pickAndSendImages(ImageSource source) async {
    try {
      List<XFile>? pickedFiles;

      if (source == ImageSource.camera) {
        var x = await ImagePicker().pickImage(source: source);
        if (x != null) {
          pickedFiles = [x];
        }
      } else {
        pickedFiles = await ImagePicker()
            .pickMultiImage(); // تعديل هنا لالتقاط صور متعددة من المعرض
      }

      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        for (XFile pickedFile in pickedFiles) {
          File imageFile = File(pickedFile.path);

          if (!selectedImages
              .any((element) => element.filename == imageFile.path)) {
            // تحويل الصور إلى MultipartFile وإضافتها للقائمة
            selectedImages.add(await dio.MultipartFile.fromFile(
              imageFile.path,
              filename: imageFile.uri.pathSegments.last,
            ));
          }
        }
        picked(true);
        images.addAll(pickedFiles.map((e) => e.path));
        log(images.length.toString());
        update();
      } else {
        print('لم يتم اختيار أي صورة');
      }
    } catch (e) {
      print('حدث خطأ أثناء اختيار الصور: $e');
    }
  }

  Future<void> sendImages() async {
    startLoading();
    var res =
        await addImageRepo.addImage(id: portId ?? 0, image: selectedImages);
    stopLoading();

    res.fold((l) {
      ToastManager.showError(l.message);
    }, (r) async {
      Get.back();
      ToastManager.showSuccess(r, true);
      Get.find<ServicesController>()
          .getServices(Get.find<ServicesController>().port!.id!.toString());
      // selectedImages.clear();
      // await getimagesByServicesid();
// Get.offAllNamed(Routes)
    });
  }

  void removeIfExists(File file) {
    print(selectedImages[0].filename);
    String fileName = basename(file.path);
    print("dddd$fileName");
    // البحث عن فهرس العنصر في selectedImages بناءً على المسار
    int index =
        selectedImages.indexWhere((image) => image.filename == fileName);

    if (index != -1) {
      // إذا تم العثور على العنصر، قم بإزالته
      selectedImages.removeAt(index);
      log('تمت إزالة الصورة الموجودة عند الفهرس $index: $file');
      print('القائمة بعد الحذف: $selectedImages');
    } else {
      log('الصورة غير موجودة في القائمة: $file');
    }
    print(selectedImages);
    update(); // تحديث الحالة إذا كنت تستخدم GetX
  }

  Future<void> getimagesByPortid() async {
    // isLoading = true;
    // update();
    var res = await addImageRepo.getportImageid(portId ?? 0);
    // isLoading = false;
    update();
    res.fold((l) {
      ToastManager.showError(l);
      isError = true;
      update();
    }, (r) {
      images.value = r;
      update();
    });
  }

  Future<void> removeImage({required String imagee}) async {
    startLoading();
    var res = await addImageRepo.deleteImage(id: portId ?? 0, image: imagee);
    stopLoading();

    res.fold((l) {
      ToastManager.showError(l.message);
    }, (r) async {
      ToastManager.showSuccess(r, true);
      await getimagesByPortid();
    });
  }

  @override
  void onInit() async {
    super.onInit();
    portId = Get.arguments["portId"];
    print("portId: $portId");
    getimagesByPortid();
    // if (Get.arguments["isEdit"]) {
    //   await getimagesByPortid();
    // }
  }
}
