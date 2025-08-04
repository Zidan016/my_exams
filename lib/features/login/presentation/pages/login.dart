import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:my_exams/features/home/Chome.dart';
import 'package:my_exams/features/home/home.dart';
import 'package:my_exams/features/login/data/repository/RepLogin.dart';
import 'package:my_exams/core/service/ApiService.dart';
import 'package:my_exams/core/service/LocalService.dart';
import 'package:my_exams/core/style/styles.dart';
import 'package:my_exams/features/student/presentation/pages/mainStudent.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Chome chome = Get.find<Chome>();
  LocalService pref = LocalService();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  RepLogin repLogin = RepLogin(api: ApiService(), pref: LocalService());
  List<String> role = [];
  bool obscure = false;
  bool rememberMe = false;
  setRole()async{
    role = await pref.getRole();
  }

  popUpSelect() {
    Get.dialog(
      AlertDialog(
        title: Text('Pilih Role'),
        content: SizedBox(
          width: 300,
          height: 300,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: role.length,
            itemBuilder: (context, index) {
              final data = role[index];
              return ListTile(
                title: Text(data == '1' ? 'Admin' : data == '3' ? 'Guru' : data == '4' ? 'Pengawas' : data == '5' ? 'Siswa' : 'Manajer (belum ada)'),
                onTap: () async {
                  selectedRole(data);
                  await pref.setOneRole(data);
                  await pref.setRememberMe(rememberMe);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  selectedRole(data){
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

  login()async{
    EasyLoading.show(status: 'Loading...');
    final respone = await repLogin.login(username.text, password.text);
    EasyLoading.dismiss();
    if(respone == true){
      setRole();
      Future.delayed(Duration(milliseconds: 50), () {
        popUpSelect();
      });
    }else if(respone == false){
      MyStyles.snackbar('Username atau Kata sandi anda salah');
    }else{
      MyStyles.snackbar('Terjadi kesalahan, silahkan coba lagi');
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body:
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyStyles.textHeadlineSmall('Selamat Datang'),
                const SizedBox(height: 10,),
                MyStyles.textHeadlineSmall('Silahkan mengisi form login'),
                const SizedBox(height: 50,),
                MyStyles.textfield('Username', username),
                const SizedBox(height: 10,),
                MyStyles.obscureText('Password', password, obscure),
                const SizedBox(height: 3,),
                Row(
                  children: [
                    MyStyles.textLightSmall('Tampilkan sandi'),
                    SizedBox(width: 3,),
                    Checkbox(
                      value: obscure, 
                      onChanged: (value) {
                        setState(() {
                          obscure = value!;
                        });
                      },
                    )
                  ],
                ),
                const SizedBox(height: 50,),
                Center(
                  child: Column(
                    children: [
                      MyStyles.myButton('Login', ()async{
                        await login();
                      }),
                      SizedBox(height: 3,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyStyles.textLightSmall('Ingat saya'),
                          SizedBox(width: 3,),
                          Checkbox(
                            value: rememberMe, 
                            onChanged: (value) {
                              setState(() {
                                rememberMe = value!;
                              });
                            },
                          )
                        ],
                      ),
                    ],
                  )
                )
              ],
            ),  
          ),
        )
    );
  }
}