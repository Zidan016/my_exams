import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_exams/core/service/ApiService.dart';
import 'package:my_exams/core/service/LocalService.dart';
import 'package:my_exams/core/style/styles.dart';
import 'package:my_exams/features/home/Chome.dart';
import 'package:my_exams/features/home/home.dart';
import 'package:my_exams/features/login/presentation/pages/login.dart';
import 'package:my_exams/features/student/presentation/pages/mainStudent.dart';

class Checking extends StatefulWidget {
  const Checking({super.key});

  @override
  State<Checking> createState() => _CheckingState();
}

class _CheckingState extends State<Checking> {
  ApiService service = Get.find<ApiService>();
  Chome chome = Get.find<Chome>();
  LocalService pref = LocalService();

  void check()async{
    final getVerify = await service.verify();
    if(getVerify == true){
      var isRemember = await pref.getRememberMe();
      isRemember == true ? rememberTrue() : Get.offAll(Login());
    }else{
      Get.offAll(Login());
    }
  }

  void rememberTrue()async{
    var data = await pref.getOneRole();
    if(data == '1'){
      chome.isAdmin.value = true;
      chome.isGuru.value = false;
      chome.isPengawas.value = false;
      chome.setMenu();
      Get.offAll(()=>Home());
    }else if(data == '3'){
      chome.isAdmin.value = false;
      chome.isGuru.value = true;
      chome.isPengawas.value = false;
      chome.setMenu();
      Get.offAll(()=>Home());
    }else if(data == '4'){
      chome.isAdmin.value = false;
      chome.isGuru.value = false;
      chome.isPengawas.value = true;
      chome.setMenu();
      Get.offAll(()=>Home());
    }else if(data == '5'){
      chome.isAdmin.value = false;
      chome.isGuru.value = false;
      chome.isPengawas.value = false;
      Get.offAll(()=>Mainstudent());
    }else{
      MyStyles.snackbar('Role tidak ditemukan');
    }
  }

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    check();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}