import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:my_exams/core/style/styles.dart';
import 'package:my_exams/features/items/presentation/controller/Citem.dart';
import 'package:my_exams/features/items/presentation/pages/itemStandart.dart';
import 'package:my_exams/features/package/data/models/MPackage.dart';
import 'package:my_exams/features/package/data/repository/PackageRepository.dart';

class Csecondpackage extends GetxController{
  Packagerepository rep = Get.find<Packagerepository>();
  Citem citem = Get.find<Citem>();
  var dept = 0.obs;
  var mFirstPackage = Rxn<PackageModel>();
  var listPackage = <PackageModel>[].obs;
  var mPackage = Rxn<PackageModel>();
  var mSubPackage = Rxn<PackageModel>();
  var isEdit = false.obs;
  var isEditSub = false.obs;
  var title = TextEditingController().obs;
  var titleSub = TextEditingController().obs;
  var description = TextEditingController().obs;
  var descriptionSub = TextEditingController().obs;
  var durationSub = TextEditingController().obs;
  var randomItem = false.obs;
  var itemDuration = false.obs;
  var btnMainItems = false.obs;

  getParent()async{
    final respone = await rep.byParent(mPackage.value!.id);
    listPackage.value = respone;
  }

  checkPackage()async{
    final respone = await rep.checkPackage(mPackage.value!.id);
    if(respone != true){
      btnMainItems.value = false;
    }else{
      btnMainItems.value = true;
    }
    print('main : ${btnMainItems.value}');
  }

  setUI()async{
    if(isEdit.value == true){
      btnMainItems.value = false;
      await getParent();
      await Future.delayed(Duration(milliseconds: 500));
      title.value.text = mPackage.value!.title;
      description.value.text = mPackage.value!.description ?? "";
      if (listPackage.length > 0) {
        final firstItem = listPackage.first;
        itemDuration.value = firstItem.itemDuration == 1 ? true : false;
        print('parent tidak null');
      }
      durationSub.value.text = mPackage.value?.duration.toString() ?? "0";
      await checkPackage();   
    }else{
      title.value.text = "";
      description.value.text = "";
      itemDuration.value = false;
      listPackage.clear();
      durationSub.value.text = "0";
      btnMainItems.value = false;
    }
  }

  setPackage(){
    String code = title.value.text.replaceAll(' ', '-');
    PackageModel model = PackageModel(
      id: isEdit.value == true ? mPackage.value!.id : "",
      title: title.value.text,
      description: description.value.text,
      isToefl: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      code: null,
      duration: int.tryParse(durationSub.value.text) ?? 0,
      level: 0,
      maxScore: 0,
      randomItem: itemDuration.value == true ? 1 : 0,
      parentId: mFirstPackage.value!.id,
      note: null,
      config: '${mFirstPackage.value?.config}.${code}',
      depth: dept.value,
      isEncrypted: 0,
      distributionOptions: null,
      itemDuration: itemDuration.value == true ? 1 : 0,
    );
    return model;
  }

  beforeExecute(){
    if(title.value.text.isEmpty || description.value.text.isEmpty ){
      MyStyles.snackbar("Judul dan Deskripsi tidak boleh kosong");
    }else{
      addOrUpdate();
    }
  }

  addOrUpdate()async{
    final package = setPackage();
    if(isEdit.value == true){
      await rep.update(package!);
      Get.back();
      // respone != false ? MyStyles.snackbar("Berhasil mengupdate data") : MyStyles.snackbar("Gagal mengupdate data");
    }else{
      await rep.add(package!);
      Get.back();
      // respone != false ? MyStyles.snackbar("Berhasil menambah data") : MyStyles.snackbar("Gagal menambah data");
    }
  }

  setSub(){
    if(isEditSub.value == true){
      print(mSubPackage.value?.toJson());
      titleSub.value.text = mSubPackage.value!.title;
      descriptionSub.value.text = mSubPackage.value?.description ?? "";
      randomItem.value = mSubPackage.value?.randomItem == 0 ? false : true;
    }else{
      titleSub.value.text = "";
      descriptionSub.value.text = "";
      randomItem.value = false;
    }
  }

  popUpSub() {
    setSub();
    Get.defaultDialog(
      title: isEditSub == true ? "Edit Paket" : "Tambah Paket",
      content: SingleChildScrollView(
        child: Column(
          children: [
            MyStyles.textfield('Judul', titleSub.value),
            const SizedBox(height: 5),
            MyStyles.textfield('Deskripsi', descriptionSub.value),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // const Text('Durasi per soal (12 detik)'),
                // Obx(() => Checkbox(
                //       value: itemDuration.value,
                //       onChanged: (bool? value) {
                //         itemDuration.value = value ?? false;
                //       },
                //     )),
                const Text('Acak soal'),
                Obx(() => Checkbox(
                      value: randomItem.value,
                      onChanged: (bool? value) {
                        randomItem.value = value ?? false;
                      },
                    )),
              ],
            ),
          ],
        ),
      ),
      confirm: MyStyles.myButton("Simpan", () {
        print('simpan');
        beforeExecuteSub();
      }),
      cancel: MyStyles.myButton("Batal", () {
        Get.back();
      }),
    );
  }

  setSubPackage() {
    final code = titleSub.value.text.replaceAll(' ', '-').toLowerCase();
    PackageModel sub = mPackage.value!.copyWith(
      id: mSubPackage.value?.id ?? "",
      title: titleSub.value.text,
      description: descriptionSub.value.text,
      depth: mPackage.value!.depth + 1,
      duration: 0,
      itemDuration: itemDuration.value == true ? 1 : 0,
      parentId: mPackage.value!.id,
      config: '${mPackage.value!.config}.${code}',
      randomItem: randomItem.value == true ? 1 :0
    );
    addOrUpdateSub(sub);
  }

  beforeExecuteSub(){
    if(titleSub.value.text.isEmpty || descriptionSub.value.text.isEmpty ){
      MyStyles.snackbar("Judul dan Deskripsi tidak boleh kosong");
    }else{
      setSubPackage();
    }
  }

  addOrUpdateSub(PackageModel model)async{
    if(isEditSub.value == true){
      await rep.update(model);
      Get.back();
      // respone != false ? MyStyles.snackbar("Berhasil mengupdate data") : MyStyles.snackbar("Gagal mengupdate data");
      getParent();
    }else{
      await rep.add(model);
      Get.back();
      // respone != false ? MyStyles.snackbar("Berhasil menambah data") : MyStyles.snackbar("Gagal menambah data");
      getParent();
    }
  }

  gotoItem(PackageModel model){
    citem.mPackage.value = model;  
    print("Dari package : \n ${model.toJson()}");
    Get.to(Itemstandart());
  }

  onDeletePackage(PackageModel model)async{
    MyStyles.information(
      'Apakah anda yakin ingin menghapus paket ini ?',
      title: "Hapus Paket",
      onOk: () async{

        final respone = await rep.delete(model.id);
        if(respone != false){
          Get.back();
          await getParent();
        }
      },
      isCancel: true
    );
  }
}