import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_exams/core/style/styles.dart';
import 'package:my_exams/features/participants/presentation/controller/CParticipant.dart';

class searchParticipat extends StatefulWidget {
  const searchParticipat({super.key});

  @override
  State<searchParticipat> createState() => searchParticipatState();
}

class searchParticipatState extends State<searchParticipat> {
  Cparticipant partControl = Get.find<Cparticipant>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      partControl.searchUsers();
      partControl.scroll.value.addListener((){
        if(partControl.scroll.value.position.pixels >=
          partControl.scroll.value.position.maxScrollExtent - 100) {
          partControl.loadMore2();
        }
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cari Paket'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          partControl.addParticipant();
        }, child: Icon(Icons.save),),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Obx(()=> Column(
            children: [
              MyStyles.textfield('Cari peserta', partControl.searchParticipat.value, onChanged: (value){
                partControl.search2(value);
              }),
              const SizedBox(height: 10,),
              Expanded(
                child: ListView.builder(
                  controller: partControl.scroll.value,
                  itemCount: partControl.listSearchPaged.length,
                    itemBuilder: (context, index) {
                    final data = partControl.listSearchPaged[index];
                    return CheckboxListTile(
                      title: Text(data.name),
                      subtitle: Text(data.username),
                      value: partControl.selectedUsers.indexWhere((id) => id.id == data.id) != -1,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            partControl.addUser(data);
                          } else {
                            partControl.selectedUsers.removeWhere((user) => user.id == data.id);
                          }
                        });
                      },
                    );
                    }
                )
              )
            ],
          ),) 
        ),
      ),
    );
  }
}