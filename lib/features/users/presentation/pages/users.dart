import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_exams/core/style/styles.dart';
import 'package:my_exams/features/users/presentation/controller/UserController.dart';
import 'package:my_exams/features/users/presentation/pages/editUsers.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  UserController controller = Get.find<UserController>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      controller.getStudent();
      controller.scroll.value.addListener(() {
      if (controller.scroll.value.position.pixels >=
          controller.scroll.value.position.maxScrollExtent - 100) {
        controller.loadMore();
      }
    });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          controller.isEdit.value = false;
          Get.to(Editusers());
        }, child: Icon(Icons.add),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Obx(()=> Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyStyles.textfield('Cari Data', controller.searchData.value, onChanged: (value) {
                controller.search(value);
              },),
              SizedBox(height: 5,),
              MyStyles.myButton('Ganti role', (){
                controller.showRoleSelectionPopup();
              }),
              SizedBox(height: 15,),
              Expanded(
                child: ListView.builder(
                  controller: controller.scroll.value,
                  itemCount: controller.listPaged.length,
                  itemBuilder: (context, index){
                    final data = controller.listPaged[index];
                    return MyStyles.myCard(
                      data.users.name, 
                      [data.users.username, data.users.email], [Icons.edit], 
                      [()async{
                        controller.mUsers.value = data;
                        controller.isEdit.value = true;
                        controller.listRoles.value = data.roles;
                        await Get.to(()=>Editusers())?.then((_){
                          controller.getStudent();
                        });
                      }]);
                  }
                )
              )
            ],
          )),
        ),
      ),
    );
  }
}