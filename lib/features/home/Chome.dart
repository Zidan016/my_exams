import 'package:get/get.dart';
import 'package:my_exams/core/service/LocalService.dart';

class Chome extends GetxController{
  var isAdmin = false.obs;
  var isGuru = false.obs;
  var isPengawas = false.obs;
  var attachment = false.obs;
  var package = false.obs;
  var users = false.obs;
  var exam = false.obs;

  LocalService pref = LocalService();
  var username = "".obs;
  var role = "".obs;

  setUI()async{
    username.value = await pref.getUsername();
    var data = await pref.getOneRole();
    role.value = data == '1' ? 'Admin' : data == '3' ? 'Guru' : data == '4' ? 'Pengawas' : data == '5' ? 'Siswa' : 'Manajer (belum ada)';
    print('Username : ${username.value}, Roles : ${role.value}');
  }

  setMenu(){
    if(isAdmin.value == true){
      attachment.value = true;
      package.value = true;
      users.value = true;
      exam.value = true;
  }else if(isGuru.value == true){
      attachment.value = true;
      package.value = true;
      users.value = false;
      exam.value = true;
    }else{
      attachment.value = false;
      package.value = false;
      users.value = false;
      exam.value = false;
    }
  }
}