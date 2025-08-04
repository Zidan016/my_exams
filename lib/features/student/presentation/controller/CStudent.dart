import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:my_exams/core/helper/web_fullscreen_helper_main.dart';
import 'package:my_exams/core/style/styles.dart';
import 'package:my_exams/features/attachment/data/models/MAttachment.dart';
import 'package:my_exams/features/exams/data/models/MExams.dart';
import 'package:my_exams/features/student/data/models/participantItemAnswers.dart';
import 'package:my_exams/features/student/data/models/participantLogs.dart';
import 'package:my_exams/features/student/data/models/participantSection.dart';
import 'package:my_exams/features/student/data/models/participantSectionItemAttempts.dart';
import 'package:my_exams/features/student/data/models/participantSectionItems.dart';
import 'package:my_exams/features/student/data/models/sectionItemAnswers.dart';
import 'package:my_exams/features/student/data/repository/RepStudent.dart';
import 'package:my_exams/features/student/presentation/widget/examSoal.dart';

class Cstudent extends GetxController {
  Repstudent rep = Get.find<Repstudent>();

  var question = <Sectionitemanswers>[].obs;
  var listAnswer = <ParticipantItemAnswers>[].obs;
  var mAttachment = <AttachmentModel>[].obs;
  var mItems = Rxn<Participantsectionitems>();
  var mSection = Rxn<ParticipantSection>();
  var mAttempts = Rxn<ParticipantSectionItemAttempts>();
  var mExams = Rxn<MExams>();
  var listSection = <ParticipantSection>[].obs;

  var audioplayers = AudioPlayer().obs;
  var isPlay = false.obs;
  var currentIndex = 0.obs;
  var isFullscreen = false.obs;
  var isEnd = false.obs;
  var isItemDuration = false.obs;
  var duration = 0.obs;
  var itemDuration = 0.obs;
  var isStart = 0.obs;
  var isFinish = 0.obs;
  var btnNext = true.obs;
  var btnPrev = false.obs;
  Timer? timer;
  Timer? timerItem;

  listeningSection()async{
    final respone = await rep.listeningSection(mSection.value?.participantId ?? "");
    listSection.value = respone;
  }

  getListeningSectionIO(){
    rep.getListeningSection((onData){
      listSection.value = onData;
      ParticipantSection? getSection = onData.firstWhereOrNull((it) => it.id == mSection.value?.id);
      print(getSection?.toJson());
      if(getSection?.endedAt != null){
        endExam();
      }
    }, mSection.value?.participantId ?? "");
  }

  setDuration(){
    timer?.cancel();
    duration.value = mSection.value?.remainingTime ?? 0;
    print(duration.value);
    if(duration.value != 0){
      timer = Timer.periodic(Duration(seconds: 1), (timer){
        if(duration.value == 0){
          timer.cancel();
          endExam();
        }else{
          duration.value--;
        }
      });
    }
  }

  void setUI(List<Sectionitemanswers> items) {
    isItemDuration.value = (mSection.value?.itemDuration == 1) ? true : false;
    question.assignAll(items);
    if (items.isNotEmpty) {
      loadSoal(0);
    }
    _updateButtonStates();
  }

  void loadSoal(int index) {
    if (index < 0 || index >= question.length) return;
    currentIndex.value = index;
    final q = question[index];
    mItems.value = q.particiapantSectionItems;
    listAnswer.assignAll(q.participantItemAnswers);
    mAttempts.value = q.participantSectionItemAttempts;
    mAttachment.value = q.attachment;
    _updateButtonStates();
  }

  updatedAttemps() async {
    final current = question[currentIndex.value];

    final updated = current.copyWith(
      participantSectionItemAttempts: mAttempts.value ?? null,
    );

    question[currentIndex.value] = updated;

    final updatedSection = mSection.value?.copyWith(
      remainingTime: duration.value
    );

    if (mAttempts.value != null) {
      final updateData = await rep.doExams(
        updated.particiapantSectionItems.id,
        updated.participantSectionItemAttempts!,
        updatedSection!,
      );
      print('terjawab');
      updateData != true ? MyStyles.snackbar('Periksa jaringan anda') : true;
    } else {
      print('lewati');
    }
  }

  Widget soal() {
    return ExamsSoal(
      key: ValueKey(currentIndex.value),
      number:  mItems.value?.label != null && int.tryParse(mItems.value!.label) != null
          ? 'Soal nomor ${mItems.value!.label}'
          : '${mItems.value!.label}',
      questionHtml: mItems.value?.content ?? "",
      subContent: mItems.value?.subContent,
      answers: listAnswer,
      attempts: mAttempts.value,
      onChanged: onAnswerSelected,
      attachments: mAttachment,
      itemDuration: isItemDuration.value,
      onAudioComplete: nextSoal,
    );
  }

  void onAnswerSelected(int? index) {
    if (index != null && index >= 0 && index < listAnswer.length && listAnswer.isNotEmpty) {
      final selected = listAnswer[index];

      mAttempts.value = ParticipantSectionItemAttempts(
        id: mAttempts.value?.id ?? "",
        participantSectionItemId: mItems.value?.id ?? "",
        answer: selected.content ?? "",
        attemptNumber: 1,
        score: selected.correctAnswer == 1 ? 1 : 0,
        isCorrect: selected.correctAnswer,
      );
    } else {
      mAttempts.value = null;
    }
  }

  void nextSoal() async{
    if (currentIndex.value < question.length - 1) {
      await updatedAttemps();
      loadSoal(currentIndex.value + 1);
    }
    _updateButtonStates();
  }

  void prevSoal()async{
    if (currentIndex.value > 0) {
      await updatedAttemps();
      loadSoal(currentIndex.value - 1);
    }
    _updateButtonStates();
  }

  void _updateButtonStates() {
    btnPrev.value = currentIndex.value > 0 && !isItemDuration.value;
    btnNext.value = currentIndex.value < question.length - 1;
  }

  popUpEnd(){
    MyStyles.information(
      'Apakah anda yakin ingin mengakhiri sesi ini ?', 
      title: 'Akhiri Sesi',
      isCancel: true,
      onOk: () {
        endExam();
        Get.back();
      },
    );
  }

  void endExam() async{
    isEnd.value = true;
    await updatedAttemps();
    await updateLogs();
    final respone = await rep.endSection(mSection.value!);
    if(respone == true){
      exitFullScreen();
      Get.back();
    }
  }

  void onPopUp()async{
    await updatedAttemps();
    MyStyles.showQuestionPopup(question, loadSoal, endExam);
  }

  Future<bool> onWillPop() async {
    if (isFullscreen.value) {
      print('Back button pressed while fullscreen');
      exitFullScreen();
      return false;
    }
    return true;
  }

  void enterFullScreen()async{
    if (kIsWeb) {
      WebFullscreenHelper.enterFullScreen();
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }
    isFullscreen.value = true;
    isEnd.value = false;
    await updateLogs();
  }

  void exitFullScreen()async{
    if (kIsWeb) {
      WebFullscreenHelper.exitFullScreen();
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    isFullscreen.value = false;
    await updateLogs();
  }

  setLogs(){
    final content = isFullscreen.value 
      ? 'connected to server !'
      : isEnd.value 
        ? 'disconnected from server !'
        :  'possible open another app !' ;
    final tags = isFullscreen.value 
      ? ["connection", "connected"]
      : isEnd.value 
        ?  ["connection", "disconnected"]
        : ["security", "mouselave"];
    final logs = ParticipantLogs(
      id: 0, 
      partcipantId: mSection.value?.participantId ?? "", 
      content: content,
      tags: tags.toString(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now()
    );
    isStart.value = isFullscreen.value ? 1 : 0;
  return logs;
  }

  updateLogs()async{
    final data = setLogs();
    final statusNumber = isFullscreen.value ? 1 : isEnd.value ? 2 : 0;
    final respone = await rep.logs(data, mExams.value?.id ?? "", isStart.value, statusNumber);
    if(respone != null){
      print('logs berhasil diupdate');
    }else{
      print('logs gagal diupdate');
    }
  }
}
