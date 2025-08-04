import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_exams/core/helper/PaggingHelper.dart';
import 'package:my_exams/core/service/LocalService.dart';
import 'package:my_exams/features/exams/data/models/MExams.dart';
import 'package:my_exams/features/package/data/models/MPackage.dart';
import 'package:my_exams/features/participants/presentation/pages/participantSection.dart';
import 'package:my_exams/features/student/data/models/participantSection.dart';
import 'package:my_exams/features/student/data/repository/RepStudent.dart';
import 'package:my_exams/features/student/presentation/controller/CSection.dart';
import 'package:my_exams/features/student/presentation/pages/sectionStudent.dart';

class Cuexmas extends GetxController{
  Repstudent rep = Get.find<Repstudent>();
  LocalService pref = LocalService();
  Csection controlSection = Get.find<Csection>();
  var listUp = <MExams>[].obs;
  var listNow = <MExams>[].obs;
  var listEnd = <MExams>[].obs;
  var scroll = ScrollController().obs;
  var listpaged = <MExams>[].obs;
  late PaginationHelper<MExams> paginator;
  var listSection = <ParticipantSection>[].obs;
  var mExams = Rxn<MExams>();
  var searchFiled = TextEditingController().obs;

  getExams()async{
    listUp.clear();
    final data = await rep.upComingExam();
    listUp.value = data;
  }

  getNow()async{
    listNow.clear();
    final data = await rep.nowComingExam();
    listNow.value = data;
  }

  getEnd()async{
    listEnd.clear();
    final data = await rep.endComingExam();
    listEnd.value = data;
    
    paginator = PaginationHelper<MExams>(
      fullList: data,
      itemsPerPage: 10,
      filterFunc: (p0, p1) => p0.name.toLowerCase().contains(p1.toLowerCase()),
    );

    listpaged.value = paginator.loadMore();

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

  getSection(MExams exams)async{
    mExams.value = exams;
    final respone = await rep.getSection(mExams.value!.id);
    listSection.value = respone;
    controlSection.mExams.value = mExams.value!;
    controlSection.listSection.assignAll(listSection);
    Get.to(Sectionstudent());
  }

  gotoPreview(MExams exams)async{
    mExams.value = exams;
    controlSection.mExams.value = exams;
    var id = await pref.getId();
    PackageModel model = await rep.packageById(exams.packageId?? "");
    controlSection.isSiswa.value = true;
    controlSection.userId.value = id;
    controlSection.mPackage.value = model;
    Get.to(()=> PreviewSection());
  }

}