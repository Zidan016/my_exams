import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_exams/core/helper/PaggingHelper.dart';
import 'package:my_exams/features/student/data/models/participantSection.dart';
import 'package:my_exams/features/student/data/models/sectionItemAnswers.dart';
import 'package:my_exams/features/student/data/repository/RepStudent.dart';

class Cpreview extends GetxController{
  var mSection = Rxn<ParticipantSection>();
  var listQuiz = <Sectionitemanswers>[].obs;
  var listPaged = <Sectionitemanswers>[].obs;
  var scroll = ScrollController().obs;
  late PaginationHelper<Sectionitemanswers> paginator;
  Repstudent rep = Get.find<Repstudent>();

  getQuiz()async{
    final respone = await rep.getItemAnswer(mSection.value?.id);
    listQuiz.value = respone;

    paginator = PaginationHelper<Sectionitemanswers>(fullList: listQuiz);
    listPaged.value = paginator.loadMore();
  }

  void loadMore() {
      final moreData = paginator.loadMore();
      if (moreData.isNotEmpty) {
        listPaged.addAll(moreData);
      }
  }
}