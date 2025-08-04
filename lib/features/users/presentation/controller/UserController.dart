
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_exams/core/helper/PaggingHelper.dart';
import 'package:my_exams/core/style/styles.dart';
import 'package:my_exams/features/users/data/models/MRoles.dart';
import 'package:my_exams/features/users/data/models/MUsers.dart';
import 'package:my_exams/features/users/data/models/MUsersRoles.dart';
import 'package:my_exams/features/users/data/repository/UsersRepository.dart';

class UserController extends GetxController{
  UserRepository rep = Get.find<UserRepository>();
  var searchData = TextEditingController().obs;
  var listUsers = <MUsersRoles>[].obs;
  var listPaged = <MUsersRoles>[].obs;
  var scroll = ScrollController().obs;
  late PaginationHelper<MUsersRoles> pagination;
  var mUsers = Rxn<MUsersRoles>();
  var nameField = TextEditingController().obs;
  var passField = TextEditingController().obs;
  var usernameField = TextEditingController().obs;
  var emailField = TextEditingController().obs;
  var isEdit = false.obs;
  var deleted = false.obs;

  var showPass = false.obs;

  var selectedRoles = <String>[].obs;
  var listRoles = <MRoles>[].obs;
  var roles = [
    {'id': 1, 'name': 'Admin'},
    {'id': 3, 'name': 'Teacher'},
    {'id': 4, 'name': 'Proctor'},
    {'id': 5, 'name': 'Student'}
  ];

  void toggleRole(int roleId) {
    var role = roles.firstWhere(
      (r) => r['id'] == roleId,
      orElse: () => {},
    );

    if (role.isNotEmpty) {
      var roleName = role['name'];
      if (selectedRoles.contains(roleName)) {
        selectedRoles.remove(roleName);
      } else {
        selectedRoles.add(roleName as String);
      }
    }
  }

  getStudent()async{
    final data = await rep.getStudent();
    listUsers.value = data;

    pagination = PaginationHelper<MUsersRoles>(
      fullList: listUsers,
      itemsPerPage: 10,
      filterFunc: (p0, p1) => p0.users.username.toLowerCase().contains(p1.toLowerCase()),
    );

    listPaged.value = pagination.loadMore();
  }

  getAdmin()async{
    final data = await rep.getAdmin();
    listUsers.value = data;
    pagination = PaginationHelper<MUsersRoles>(
      fullList: listUsers,
      itemsPerPage: 10,
      filterFunc: (p0, p1) => p0.users.username.toLowerCase().contains(p1.toLowerCase()),
    );

    listPaged.value = pagination.loadMore();
  }

  nonAktif()async{
    MyStyles.information(
      'Apakah anda yakin ingin mengnon-aktifkan akun ini ?',
      title: "Non-aktif Akun",
      onOk: () async{
        final respone = await rep.nonAktif(mUsers.value?.users.id.toString() ?? "");
        if(respone != false){
          MyStyles.snackbar('Berhasil non-aktifkan akun');
          Get.back();
        }else{
          MyStyles.snackbar('Gagal non-aktifkan akun');
        }
      },
      isCancel: true
    );
  }

  getTeacher()async{
    final data = await rep.getTeacher();
    listUsers.value = data;
    pagination = PaginationHelper<MUsersRoles>(
      fullList: listUsers,
      itemsPerPage: 10,
      filterFunc: (p0, p1) => p0.users.username.toLowerCase().contains(p1.toLowerCase()),
    );

    listPaged.value = pagination.loadMore();
  }

  getProctor()async{
    final data = await rep.getProctor();
    listUsers.value = data;
    pagination = PaginationHelper<MUsersRoles>(
      fullList: listUsers,
      itemsPerPage: 10,
      filterFunc: (p0, p1) => p0.users.username.toLowerCase().contains(p1.toLowerCase()),
    );

    listPaged.value = pagination.loadMore();
  }

  void loadMore() {
      final moreData = pagination.loadMore();
      if (moreData.isNotEmpty) {
        listPaged.addAll(moreData);
      }
    }

  void search(String query) {
    pagination.search(query);
    listPaged.value = pagination.loadMore();
  }

  showRoleSelectionPopup() {
    Get.defaultDialog(
      title: "Select Role",
      content: Column(
        children: [
          SizedBox(height: 10,),
          ElevatedButton(
            onPressed: () async {
              await getAdmin();
              Get.back();
            },
            child: Text("Admin"),
          ),
          SizedBox(height: 10,),
          ElevatedButton(
            onPressed: () async {
              await getTeacher();
              Get.back();
            },
            child: Text("Teacher"),
          ),
          SizedBox(height: 10,),
          ElevatedButton(
            onPressed: () async {
              await getProctor();
              Get.back();
            },
            child: Text("Proctor"),
          ),
          SizedBox(height: 10,),
          ElevatedButton(
            onPressed: () async {
              await getStudent();
              Get.back();
            },
            child: Text("Student"),
          ),
        ],
      ),
    );
  }

  setUI(){
    if(isEdit.value == true){
      usernameField.value.text = mUsers.value?.users.username.toString() ?? "";
      nameField.value.text = mUsers.value?.users.name.toString() ?? "";
      emailField.value.text = mUsers.value?.users.email.toString() ?? "";
      passField.value.text = "";
      selectedRoles.clear();
      for (var role in roles) {
        if (listRoles.any((rl) => rl.roleId == role['id'])) {
          selectedRoles.add(role['name'] as String);
        }
      }
    }else{
      usernameField.value.text = "";
      nameField.value.text = "";
      emailField.value.text = "";
      passField.value.text = "";
    }
  }

  buttonSave(){
    if(selectedRoles.isEmpty || usernameField.value.text.isEmpty || nameField.value.text.isEmpty ||emailField.value.text.isEmpty){
      MyStyles.snackbar('Form tidak boleh kosong');
    }else{
      addOrUpdate();
    }
  }

  setItem(){
    final users = MUsers(
      id: mUsers.value?.users.id ?? 0, 
      name: nameField.value.text, 
      username: usernameField.value.text, 
      email: emailField.value.text, 
      password: passField.value.text,
      altId: null,
      createdAt: null,
      deletedAt: deleted.value ? DateTime.now() : null,
      emailVerifiedAt: null,
      rememberToken: null,
      twoFactorRecoveryCodes: null,
      twoFactorSecret: null,
      updatedAt: null
    ).toJson();

    return users;
  }

  addOrUpdate()async{
    List<Map<String, dynamic>> selectedJson = roles
    .where((role) => selectedRoles.contains(role['name']))
    .map((role) => {
          'id': role['id'],
          'name': role['name'],
        })
    .toList();

    final data = setItem();
    print(data);
    print(selectedJson);
    if(isEdit.isTrue){
      final respone = await rep.editStudent(data, selectedJson);
      Get.back();
      respone != false ? MyStyles.snackbar('Berhasil Edit data') : MyStyles.snackbar('Gagal Edit data');
    }else{
      final respone = await rep.addStudent(data, selectedJson);
      Get.back();
      respone != false ? MyStyles.snackbar('Berhasil Edit data') : MyStyles.snackbar('Gagal Edit data');
    }
  }

}