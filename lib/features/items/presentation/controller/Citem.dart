import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_exams/core/helper/PaggingHelper.dart';
import 'package:my_exams/features/items/data/models/ItemAnswer.dart';
import 'package:my_exams/features/items/data/models/MItem.dart';
import 'package:my_exams/features/items/data/repository/IARepository.dart';
import 'package:my_exams/features/package/data/models/MPackage.dart';

class Citem extends GetxController {
  Iarepository rep = Get.find<Iarepository>();
  var itemAnswer = <ItemAnswer>[].obs;
  var cari = TextEditingController().obs;
  var selectedAnswers = <int, int>{}.obs;
  late PaginationHelper<ItemAnswer> painator;
  var scroll = ScrollController().obs;
  var listpaged = <ItemAnswer>[].obs;
  var answers = <Rx<TextEditingController>>[].obs;
  var numberControll = TextEditingController().obs;

  List<Rx<TextEditingController>> copyWithAnswers(List<Rx<TextEditingController>> newAnswers) {
    answers.assignAll(newAnswers);
    return answers;
  }
  var mPackage = Rxn<PackageModel>();
  var ordetInt = 0.obs;

  getItemAnswer() async {
    final response = await rep.getItemAnswer(mPackage.value!.id);
    final data = rep.setMainItem(response);
    itemAnswer.value = data;
    ordetInt.value = itemAnswer.length;
    painator = PaginationHelper<ItemAnswer>(fullList: itemAnswer);
    listpaged.value = painator.loadMore();
  }

  loadMore(){
    final moreData = painator.loadMore();
      if (moreData.isNotEmpty) {
        listpaged.addAll(moreData);
      }
  }

  firstInit() async {
    await getItemAnswer();
    if (itemAnswer.isEmpty) {
      await rep.firstInit(mPackage.value!.id);
      getItemAnswer();
      print('kosong');
    }else{
      print('ada data');
    }
  }

  onDeleteItem(ItemModel item)async{
    Get.defaultDialog(
      title: "Hapus Item",
      middleText: "Semua data didalam item ini akan terhapus, Apakah anda yakin ingin melanjutkan ?",
      textCancel: "Batal",
      textConfirm: "Hapus",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        final response = await rep.delete(item.id);
        if (response != false) {
        await getItemAnswer();
        Get.back();
        }
      },
    );
  }

  updatedOrder(ItemModel modelTarget, ItemModel modelMoved) async {
    final respone = await rep.updatedOrder(modelTarget, modelMoved, mPackage.value?.id ?? "");
    if (respone == true) {
      await getItemAnswer();
    }
  }

}
