import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_exams/core/helper/PaggingHelper.dart';
import 'package:my_exams/core/helper/helper.dart';
import 'package:my_exams/features/exams/data/models/MExams.dart';
import 'package:my_exams/features/exams/data/models/MPackExams.dart';
import 'package:my_exams/features/exams/presentation/pages/ConfExam.dart';
import 'package:my_exams/features/package/data/models/MPackage.dart';
import 'package:my_exams/features/exams/data/repository/ExamsRepository.dart';
import 'package:my_exams/core/style/styles.dart';
import 'package:my_exams/features/participants/data/models/MUsersParti.dart';
import 'package:my_exams/features/participants/presentation/controller/CParticipant.dart';
import 'package:my_exams/features/participants/presentation/pages/ExamsParticipant.dart';

class Cexams extends GetxController{
  Examsrepository rep = Get.find<Examsrepository>();
  Cparticipant controll = Get.find<Cparticipant>();
  var cariControl = TextEditingController().obs;
  var examsList = <MPackExams>[].obs;
  var examsDraft = <MPackExams>[].obs;
  var examsNow = <MPackExams>[].obs;
  var examsEnd = <MPackExams>[].obs;
  var examsUpcoming = <MPackExams>[].obs;
  var listPaged = <MPackExams>[].obs;
  var scroll = ScrollController().obs;
  late PaginationHelper<MPackExams> paginator;
  var mExams = Rxn<MExams>();
  var mPackage = Rxn<PackageModel>();
  var isEdit = false.obs;
  var nameField = TextEditingController().obs;
  var durationField = TextEditingController().obs;
  var anytimeCheck = 0.obs;
  var multiAttempt = 0.obs;
  var autoStart = 0.obs;
  var packageId = "".obs;
  var packageName = "".obs;
  var date = DateTime.now().obs;
  var time = TimeOfDay.now().obs;
  var listParticipant = <Musersparti>[].obs;
  var mExamActive = Rxn<MPackExams>();

  getDraft()async{
    examsDraft.clear();
    final data = await rep.UpcomingExam();
    examsDraft.value = data;
  }

  getNow()async{
    examsNow.clear();
    final data = await rep.nowExam();
    examsNow.value = data;
  }

  getUpComing()async{
    examsUpcoming.clear();
    final data = await rep.upComing();
    examsUpcoming.value = data;
  }

  getEnd()async{
    examsEnd.clear();
    final data = await rep.endExam();
    examsEnd.value = data;

    paginator = PaginationHelper<MPackExams>(
      fullList: examsEnd,
      itemsPerPage: 10,
      filterFunc: (p0, p1) => p0.examsModel.name.toLowerCase().contains(p1.toLowerCase()),
    );

    listPaged.value = paginator.loadMore();
  }

  setExamsEdit(PackageModel package, MExams exams){
    mExams.value = exams;
    mPackage.value = package;
    packageId.value = package.id;
    packageName.value = package.title;
  }

  setUIEdit(){
    if (isEdit.value == true) {
      nameField.value.text = mExams.value?.name ?? "";
      durationField.value.text = mExams.value?.duration.toString() ?? "";
      anytimeCheck.value = mExams.value?.isAnytime ?? 0;
      multiAttempt.value = mExams.value?.isMultiAttempt ?? 0;
      autoStart.value = mExams.value?.automaticStart ?? 0;
      packageId.value = mExams.value?.packageId ?? "";
      date.value = mExams.value?.startedAt ?? DateTime.now();
      time.value = TimeOfDay.fromDateTime(mExams.value?.startedAt ?? DateTime.now());
    }else{
      nameField.value.text = "";
      durationField.value.text = "";
      anytimeCheck.value = 0;
      multiAttempt.value = 0;
      autoStart.value = 0;
      packageId.value = "";
      packageName.value = "";
      date.value = DateTime.now();
      time.value = TimeOfDay.now();
    }
  }

  setItem(){
    int toTimestamp = Helper.toTimestamp(date.value, time.value);
    final startDate = Helper.toMySQLDateTime(Helper.fromTimestamp(toTimestamp));
    final newExams = MExams(
      id: mExams.value?.id ?? "",
      packageId: packageId.value == "" ? null : packageId.value,
      automaticStart: autoStart.value,
      duration: mPackage.value?.duration ?? 0,
      isAnytime: anytimeCheck.value,
      isMultiAttempt: multiAttempt.value,
      endedAt: null,
      startedAt: autoStart.value == 1 ? DateTime.tryParse(startDate) : null,
      name: nameField.value.text,
      scheduledAt: isEdit.value == true ? mExams.value?.scheduledAt : null,
    );
    return newExams;
  }

  addOrsave()async{
    if (nameField.value.text.isEmpty || packageName.value.isEmpty) {
      MyStyles.information('Nama dan paket tidak boleh kosong', onOk: Get.back);
      return;
    }

    final newExams = setItem();
    if (isEdit.isTrue) {
      await rep.update(newExams);
      // MyStyles.snackbar('Berhasil Update');
    } else {
      await rep.add(newExams);
      // MyStyles.snackbar('Berhasil tambah');
    }
    Get.back();
  }

  showPopUp(){
    MyStyles.information('Periksa konfigurasi dan kelengkapan paket soal, Karena jika ujian dimulai tidak anda dapat mengubah data ujian dan paket sendiri. Apakah anda yakin memulai ujian ?', isCancel: true, onOk: (){publishExam();Get.back();});
  }

  publishExam()async{
    await controll.addParticipant();
    await rep.publishExam(mExams.value!.id);
    // if(respone == true){
    //   MyStyles.snackbar('Berhasil publish exams');
    //   Get.back();
    // }else{
    //   MyStyles.snackbar('Gagal publish');
    //   Get.back();
    // }
    Get.back();
  }

  UIexamsPublish(MPackExams model)async{
    final respone = await rep.getParticipant(model.examsModel.id);
    listParticipant.value = respone;
    mExamActive.value = model;
    await Get.to(()=>Confexam())?.then((_){
      getUpComing();
    });
  }

  startExams()async{
    await rep.startExams(mExamActive.value?.examsModel.id ?? "");
    // if(respone == true){
    //   MyStyles.snackbar('Berhasil mulai ujian');
    // }else{
    //   MyStyles.snackbar('Gagal mulai ujian');
    // }
    Get.back();
  }

  showPopUPStart()async{
    MyStyles.information('Apakah Anda yakin ingin memulai Ujian ?', onOk: (){startExams();Get.back();}, onCancel: (){Get.back();});
  }

  showPopUpDelete(String id, VoidCallback callback)async{
    MyStyles.information(
      'Jika data ini terhapus maka data yang berada di dalam paket ini akan ikut terhapus, Apakah anda yakin ingin menghapus ?',
      onOk: (){
        delete(id);
        callback;
      },
      isCancel: true);
  }

  delete(String id)async{
    await rep.del(id);
    // if(respone != false){
    //   MyStyles.snackbar('Berhasil hapus data');
    // }else{

    //   MyStyles.snackbar('Gagal hapus data');
    // }
    Get.back();
  }

  gotoExamsParticipants(MPackExams model){
    controll.mPackage.value = model.packageModel;
    controll.mExams.value = model.examsModel;
    controll.examsId.value = model.examsModel.id;
    Get.to(()=>Examsparticipant());
  }

  void loadMore() {
      final moreData = paginator.loadMore();
      if (moreData.isNotEmpty) {
        listPaged.addAll(moreData);
      }
    }

  void search(String query) {
    paginator.search(query);
    listPaged.value = paginator.loadMore();
  }
}