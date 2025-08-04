import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:my_exams/core/helper/helper.dart';
import 'package:my_exams/core/style/styles.dart';
import 'package:my_exams/features/package/data/models/MPackage.dart';
import 'package:my_exams/features/package/data/repository/PackageRepository.dart';
import 'package:my_exams/features/package/presentation/controller/CSecondPackage.dart';
import 'package:my_exams/features/package/presentation/pages/SecondPackage.dart';

class Cfirstpackage extends GetxController {
  Packagerepository rep = Get.find<Packagerepository>();
  Csecondpackage secondPackage = Get.find<Csecondpackage>();
  var listPackage = <PackageModel>[].obs;
  var mPackage = Rxn<PackageModel>();
  var isEdit = false.obs;
  var title = TextEditingController().obs;
  var description = TextEditingController().obs;
  var isToefl = false.obs;

  getParent()async{
    final respone = await rep.byParent(mPackage.value!.id);
    listPackage.value = respone;
  }

  setUI()async{
    if(isEdit.value == true){
      getParent();
      title.value.text = mPackage.value!.title;
      description.value.text = mPackage.value!.description ?? "";
      Future.delayed(Duration(milliseconds: 500));
      isToefl.value = mPackage.value!.isToefl == 1 ? true : false;
    }else{
      title.value.text = "";
      description.value.text = "";
      isToefl.value = false;
      listPackage.clear();
      mPackage.value = null;
    }
  }

  setPackage(){
    String code = title.value.text.replaceAll(' ', '');
    String random = Helper.generateRandomLetters(4);
    PackageModel model = PackageModel(
      id: isEdit.value == true ? mPackage.value!.id : "",
      title: title.value.text,
      description: description.value.text,
      isToefl: isToefl.value == true ? 1 : 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      code: 'E-${code}#${random}',
      duration: 0,
      level: 0,
      maxScore: 0,
      randomItem: 0,
      parentId: null,
      note: null,
      config: 'E-${code}',
      depth: 0,
      isEncrypted: 0,
      distributionOptions: null,
      itemDuration: 0,
    );
    print(model.toJson());
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
      final respone = await rep.update(package);
      respone != false ? Get.back() : true;
      // respone != false ? MyStyles.snackbar("Berhasil mengupdate data") : MyStyles.snackbar("Gagal mengupdate data");
    }else{
      final respone = await rep.add(package!);
      respone != false ? Get.back() : true;
      // respone != false ? MyStyles.snackbar("Berhasil menambah data") : MyStyles.snackbar("Gagal menambah data");
    }
  }

  toSecondPackage(bool isEditSub, PackageModel? data){
    secondPackage.mFirstPackage.value = mPackage.value;
    secondPackage.mPackage.value = data;
    secondPackage.isEdit.value = isEditSub;
    secondPackage.dept.value = listPackage.length + 1;
    Get.to(()=> Secondpackage())?.then((_){
      getParent();
    });
  }

  onDeletePackage(PackageModel model)async{
    MyStyles.information(
      'Apakah anda yakin ingin menghapus paket ini ?',
      title: "Hapus Paket",
      onOk: () async{

        final respone = await rep.delete(model.id);
        if(respone != false){
          Get.back();
          // MyStyles.snackbar('Berhasil Hapus data');
        }
      },
      isCancel: true
    );
  }
  
}