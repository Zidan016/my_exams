import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_exams/core/style/styles.dart';
import 'package:my_exams/features/users/presentation/controller/UserController.dart';

class Editusers extends StatefulWidget {
  const Editusers({super.key});

  @override
  State<Editusers> createState() => _EditusersState();
}

class _EditusersState extends State<Editusers> {
  UserController userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      userController.setUI();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit'),
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: 
        (){
          userController.buttonSave();
        }, child: Icon(Icons.save),
      ),

      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyStyles.textHeadlineSmall('Nama'),
              MyStyles.textfield('Nama', userController.nameField.value),

              SizedBox(height: 5),
              MyStyles.textHeadlineSmall('Username'),
              MyStyles.textfield('Username', userController.usernameField.value),

              SizedBox(height: 5),
              MyStyles.textHeadlineSmall('Email'),
              MyStyles.textfield('Email', userController.emailField.value),

              SizedBox(height: 5),
              MyStyles.textHeadlineSmall('Password (opsional)'),
              MyStyles.obscureText('Password', userController.passField.value, userController.showPass.value),
              SizedBox(height: 3,),
              Row(
                children: [
                  MyStyles.textLightSmall('Tampilkan sandi'),
                  SizedBox(width: 2,),
                  Checkbox(
                    value: userController.showPass.value, 
                    onChanged: (value){
                      userController.showPass.value = value!;
                    }
                  )
                ],
              ),
              SizedBox(height: 10),
              MyStyles.textHeadlineSmall('Roles'),

              Expanded(
                child: ListView(
                  children: userController.roles.map((role) {
                    final isSelected = userController.selectedRoles.contains(role['name']);
                    return CheckboxListTile(
                      title: Text(role['name'] as String),
                      value: isSelected,
                      onChanged: (bool? value) {
                        userController.toggleRole(role['id'] as int);
                      },
                    );
                  }).toList(),
                ),
              ),
              MyStyles.myButton('Nonaktifkan Akun',
                (){
                  userController.nonAktif();
                },
                color: Colors.red
              )
            ],
          )),
        ),
      ),

    );
  }
}