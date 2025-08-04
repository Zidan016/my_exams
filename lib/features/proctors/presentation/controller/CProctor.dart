import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_exams/core/style/styles.dart';
import 'package:my_exams/features/exams/data/models/MExams.dart';
import 'package:my_exams/features/proctors/data/models/Mprt.prtlog.dart';
import 'package:my_exams/features/proctors/data/models/prtLogs.dart';
import 'package:my_exams/features/proctors/data/models/prtUsers.dart';
import 'package:my_exams/features/proctors/data/repository/socketRep.dart';
import 'package:my_exams/features/student/data/models/participantLogs.dart';

class Cproctor extends GetxController{
  RepSocket rep = Get.find<RepSocket>();

  var listPrtStudent = <MParticipantUserLogs>[].obs;
  var listLogs = <MParticipantLogs>[].obs;
  var mLogs = Rxn<ParticipantLogs>();
  var mExams = Rxn<MExams>();
  var listExamParticipants = <MExamsParticipants>[].obs;
  var active =0.obs;
  var ready = 0.obs;
  var finished = 0.obs;
  var exams = 0.obs;

  getExamParticipant()async{
    final respone = await rep.getParticiapnt(mExams.value!.id);
    listPrtStudent.value = respone;
  }

  getLogs(prtId)async{
    final respone = await rep.getPartLogs(prtId);
    listLogs.value = respone;
  }

  getExamParticipantIO(){
    rep.getExamParticipant((data) {
      listPrtStudent.value = data;
    }, mExams.value!.id);
  }

  getLogsIO(prtId){
    rep.getLogs((data) {
      listLogs.assignAll(data);
    }, prtId);
  }

  disOrQual(String status, String prtId)async{
    final respone = await rep.disOrQual(prtId, status);
    print(respone);
    if(respone == true){
      Get.back();
      MyStyles.snackbar('Berhasil ${status}');
    }else{
      Get.back();
      MyStyles.snackbar('Gagal ${status}');
    }
  }

  setModelLogs(String status, String prtId){
    if(status == 'dis'){
      mLogs.value = ParticipantLogs(
        id: 0, 
        partcipantId: prtId, 
        content: 'disqualified',
        tags: '["security", "disqualified"]',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()
      );
    }else{
      mLogs.value = ParticipantLogs(
        id: 0, 
        partcipantId: prtId, 
        content: 'qualified',
        tags: '["security", "qualified"]',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()
      );
    }
  }

  beforeEnd(){
    MyStyles.information(
      'Apakah anda yakin mengakhiri ujian ?', 
      title: "Akhiri Ujian",
      onOk: () {
      endExam();
      },
      isCancel: true
    );
  }

  endExam()async{
    final respone = await rep.endExam(mExams.value!.id);
    if(respone == true){
      Get.back();
      Get.back();
    }else{
      MyStyles.snackbar('Gagal Mengakhiri ujian');
    }
  }

  popUpLogs(String prtId, String username){
    getLogs(prtId);
    getLogsIO(prtId);
    Get.dialog(
      AlertDialog(
      title: Text(username),
      content: SizedBox(
        width: double.maxFinite,
        child: Obx(() {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: listLogs.length,
          itemBuilder: (context, index) {
          final log = listLogs[index];
          return ListTile(
            title: Text(log.content),
            subtitle: Text('Tags: ${log.tags ?? 'No Tags'}'),
          );
          },
        );
        }),
      ),
      actions: [
        TextButton(
          onPressed: ()async{
            await disOrQual('dis', prtId);
          },
          child: Text('Disqualifikasi'),
        ),
        const SizedBox(height: 10,),
        TextButton(
          onPressed: ()async{
            await disOrQual('qual', prtId);
          },
          child: Text('Qualifikasi'),
        ),
        const SizedBox(height: 10,),
        TextButton(
        onPressed: () {
          rep.disconnectLogs(prtId);
          Get.back();
        },
        child: Text('Close'),
        ),
      ],
      ),
    );
  }

 getDashborad()async{
  final respone = await rep.getDashborad();
  listExamParticipants.value = respone;
  exams.value = listExamParticipants.fold(0, (sum, item) => sum + item.exams.length);
  active.value = listExamParticipants.fold(0, (sum, item) => sum + item.participant.where((prt) => prt.status == 'active').length);
  ready.value = listExamParticipants.fold(0, (sum, item) => sum + item.participant.where((prt) => prt.status == 'ready').length);
  finished.value = listExamParticipants.fold(0, (sum, item) => sum + item.participant.where((prt) => prt.status == 'finished').length);
 }

 socketDasboard(){
  rep.socketDashboard((onData){
    listExamParticipants.value = onData;
    exams.value = listExamParticipants.fold(0, (sum, item) => sum + item.exams.length);
    active.value = listExamParticipants.fold(0, (sum, item) => sum + item.participant.where((prt) => prt.status == 'active').length);
    ready.value = listExamParticipants.fold(0, (sum, item) => sum + item.participant.where((prt) => prt.status == 'ready').length);
    finished.value = listExamParticipants.fold(0, (sum, item) => sum + item.participant.where((prt) => prt.status == 'finished').length);
  });
 }

}