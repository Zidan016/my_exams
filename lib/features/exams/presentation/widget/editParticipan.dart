import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_exams/features/participants/presentation/controller/CParticipant.dart';
import 'package:my_exams/features/participants/presentation/pages/searchParticipant.dart';
import 'package:my_exams/core/style/styles.dart';

class Editparticipan extends StatefulWidget {
  const Editparticipan({super.key});

  @override
  State<Editparticipan> createState() => _EditparticipanState();
}

class _EditparticipanState extends State<Editparticipan> {
  Cparticipant partControl = Get.find<Cparticipant>();
  @override
  void initState() {
    super.initState();
    partControl.getUserPart();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if(partControl.examsId.value == ""){
            MyStyles.snackbar('Simpan ujian terlebih dahulu');
          }else{
            Get.to(()=> searchParticipat())?.then((_){
              partControl.getUserPart();
            });
          }
      }, child: Icon(Icons.add),),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: 
          Obx(()=> Column(
            children: [
              Expanded(
                child: 
                  ListView.builder(
                    itemCount: partControl.listUserPart.length,
                    itemBuilder: (context, index){
                      final data = partControl.listUserPart[index];
                      return MyStyles.myCard(data.mUsers.name, [data.mUsers.username], [], []);
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