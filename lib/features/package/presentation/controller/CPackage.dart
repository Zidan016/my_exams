import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_exams/core/helper/PaggingHelper.dart';
import 'package:my_exams/features/package/data/models/MPackage.dart';
import 'package:my_exams/features/package/data/repository/PackageRepository.dart';

class Cpackage extends GetxController{
  final rep = Get.find<Packagerepository>();
  var listPackage = <PackageModel>[].obs;
  var listpaged = <PackageModel>[].obs;
  var itemAwal = Rxn<PackageModel>();
  var itemUpdate = Rxn<PackageModel>();
  var fieldSearch = TextEditingController().obs;
  late PaginationHelper<PackageModel> paginator;
  var scroll = ScrollController().obs;

  @override
  void onInit() {
    super.onInit();
  }

  getMain()async{
    final respone = await rep.main();
    listPackage.value = respone;
    paginator = PaginationHelper<PackageModel>(
      fullList: listPackage,
      itemsPerPage: 10,
      filterFunc: (pkg, query)=> pkg.title.toLowerCase().contains(query.toLowerCase())
    );

    listpaged.value = paginator.loadMore();
  }

  onRefresh()async{
    getMain();
  }

  void loadMore() {
      final moreData = paginator.loadMore();
      if (moreData.isNotEmpty) {
        listpaged.addAll(moreData);
      }
    }

  void search(String query) {
    paginator.search(query);
    listpaged.value = paginator.loadMore();
  }

  onDeleteItem(PackageModel model)async{
    Get.defaultDialog(
      title: "Hapus Paket",
      middleText: "Semua data di dalam paket ini akan terhapus, Apakah anda yakin ingin melanjutkan ?",
      textCancel: "Batal",
      textConfirm: "Hapus",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        final response = await rep.delete(model.id);
        if (response != false) {
        Get.back();
        await getMain();
        }
      },
    );
  }

}