import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_exams/core/style/styles.dart';
import 'package:my_exams/features/exams/data/models/MExams.dart';
import 'package:my_exams/features/package/data/models/MPackage.dart';
import 'package:my_exams/features/participants/presentation/controller/Cpreview.dart';
import 'package:my_exams/features/participants/presentation/pages/PreviewQuestion.dart';
import 'package:my_exams/features/student/data/models/participantSection.dart';
import 'package:my_exams/features/student/data/repository/RepStudent.dart';
import 'package:my_exams/features/student/presentation/controller/CStudent.dart';
import 'package:my_exams/features/student/presentation/pages/question.dart';

class Csection extends GetxController{
  Repstudent rep = Get.find<Repstudent>();
  Cstudent controllStudent = Get.find<Cstudent>();
  Cpreview preview = Get.find<Cpreview>();
  var listSection = <ParticipantSection>[].obs;
  var mExams = Rxn<MExams>();
  var totalScore = 0.obs;
  var userId = 0.obs;
  var mPackage = Rxn<PackageModel>();
  var scoreField = TextEditingController().obs;
  var isSiswa = false.obs;

  getSection()async{
    final respone = await rep.getSection(mExams.value!.id);
    listSection.value = respone;
  }

  getSectionPreview()async{
    listSection.clear();
    totalScore.value = 0;
    final respone = await rep.getSectionPreview(mExams.value!.id, userId.value);
    print(mPackage.value?.toJson());
    listSection.value = respone;
    final score = listSection.fold<int>(0, (sum, item) => sum + (item.score));
    totalScore.value = listSection.isNotEmpty ? (score / listSection.length).toInt() : 0;
    totalScore.value = mPackage.value?.isToefl == 0 ? totalScore.value : totalScore.value * 10;
  }

  getSectionItemAnswer(ParticipantSection section)async{
    if(section.endedAt == null){
      controllStudent.mSection.value = section;
      controllStudent.mExams.value = mExams.value;
      final respone = await rep.getItemAnswer(section.id);
      controllStudent.setUI(respone);
      Get.to(()=>Question())?.then((_){
        getSection();
      });
    }else{
      MyStyles.information('Anda tidak bisa memasuki sesi ini karena anda telah mengakhiri sesi ini', onOk: () {
        Get.back();
      },);
    }
  }

  gotoPreview(ParticipantSection model){
    preview.mSection.value = model;
    Get.to(()=> Previewquestion());
  }

  fixScore(ParticipantSection models)async{
    final respone = await rep.fixScore(models);
    if(respone != false){
      await getSectionPreview();
    }
  }

  popUpedit(String id) {
    Get.defaultDialog(
      title: 'Edit Score',
      content: SizedBox(
        width: 300,
        height: 200,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: scoreField.value,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter new score',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  final newScore = int.tryParse(scoreField.value.text);
                  if (newScore != null) {
                    updtedScore(id, newScore);
                    Get.back();
                  } else {
                    MyStyles.snackbar('Invalid score');
                  }
                },
                child: Text('Update'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  updtedScore(String id, int score)async{
    final result = await rep.updatedScore(id, score);
    if(result != false){
        getSectionPreview();
      MyStyles.snackbar('Berhasil update score');
    }else{
        MyStyles.snackbar('Gagal update score');
    }
  }

}