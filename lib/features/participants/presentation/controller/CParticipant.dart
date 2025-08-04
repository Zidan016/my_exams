import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_exams/core/helper/PaggingHelper.dart';
import 'package:my_exams/features/exams/data/models/MExams.dart';
import 'package:my_exams/features/package/data/models/MPackage.dart';
import 'package:my_exams/features/participants/data/models/MParticipants.dart';
import 'package:my_exams/features/participants/presentation/pages/participantSection.dart';
import 'package:my_exams/features/student/presentation/controller/CSection.dart';
import 'package:my_exams/features/users/data/models/MUsers.dart';
import 'package:my_exams/features/participants/data/models/MUsersParti.dart';
import 'package:my_exams/features/participants/data/repository/ParticipantRepo.dart';

class Cparticipant extends GetxController{
  var listUserPart = <Musersparti>[].obs;
  var listUsers = <MUsers>[].obs;
  var selectedUsers = <MUsers>[].obs;
  var listPaged = <Musersparti>[].obs;
  var listSearchPaged = <MUsers>[].obs;
  var scroll = ScrollController().obs;
  late PaginationHelper<Musersparti> paginator;
  late PaginationHelper<MUsers> paginator2;
  var addUserPart = <Mparticipants>[].obs;
  var examsId = "".obs;
  var mExams = Rxn<MExams>();
  var mPackage = Rxn<PackageModel>();
  Participantrepo rep = Get.find<Participantrepo>();
  var searchParticipat = TextEditingController().obs;

  Csection section = Get.find<Csection>();

  getUserPart()async{
    final respone = await rep.getParticipant(examsId.value);
    listUserPart.value = respone;
    selectedUsers.value = listUserPart.map(
      (item)=> MUsers(
        id: item.mUsers.id, 
        name: item.mUsers.name, 
        username: item.mUsers.username, 
        email: item.mUsers.email, 
        password: item.mUsers.password
      )).toList();


      paginator = PaginationHelper<Musersparti>(
        fullList: listUserPart,
        itemsPerPage: 10,
        filterFunc: (p0, p1) => p0.mUsers.username.toLowerCase().contains(p1.toLowerCase()),
      );

      listPaged.value = paginator.loadMore();
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

  addUser(MUsers model){
    selectedUsers.add(model);
    update();
  }

  searchUsers()async{
    final respone = await rep.searchUsers();
    listUsers.value = respone;
    paginator2 = PaginationHelper<MUsers>(
      fullList: respone,
      itemsPerPage: 10,
      filterFunc: (p0, p1) => p0.username.toLowerCase().contains(p1.toLowerCase()),
    );
    listSearchPaged.value = paginator2.loadMore();
  }

  void loadMore2() {
      final moreData = paginator2.loadMore();
      if (moreData.isNotEmpty) {
        listSearchPaged.addAll(moreData);
      }
    }

  void search2(String query) {
    paginator2.search(query);
    listSearchPaged.value = paginator2.loadMore();
  }

  setParticipantadd(){
    final parcticipan = selectedUsers.map((user)=> Mparticipants(id: '',userId: user.id, examId: examsId.value, status: 'active'));
    addUserPart.value = parcticipan.toList();
    print(parcticipan.map((item)=> item.toJson()).toList());
  }

  addParticipant()async{
    setParticipantadd();
    await rep.addParticipant(addUserPart);
    Get.back();
  }

  gotoSection(MUsers model){
    section.mExams.value = mExams.value;
    section.mPackage.value = mPackage.value;
    section.userId.value = model.id;
    section.isSiswa.value = false;
    Get.to(()=> PreviewSection());
  }
}