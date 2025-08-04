import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_exams/core/style/styles.dart';
import 'package:my_exams/features/student/presentation/controller/Cuexmas.dart';

class Endstudent extends StatefulWidget {
  const Endstudent({super.key});

  @override
  State<Endstudent> createState() => _UpstudentState();
}

class _UpstudentState extends State<Endstudent> {
  Cuexmas controll = Get.find<Cuexmas>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      controll.getEnd();
      controll.scroll.value.addListener(() {
      if (controll.scroll.value.position.pixels >=
          controll.scroll.value.position.maxScrollExtent - 100) {
        controll.loadMore();
      }
    });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Obx(
            ()=> Column(
            children: [
              MyStyles.textfield('Cari Ujian', controll.searchFiled.value, onChanged: (value) {
                controll.search(value);
              },),
              SizedBox(height: 10,),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: ()async{controll.getEnd();},
                  child: ListView.builder(
                    controller: controll.scroll.value,
                    itemCount: controll.listpaged.length,
                    itemBuilder: (context, index){
                      final data = controll.listpaged[index];
                      return InkWell(
                        onTap: (){
                          controll.gotoPreview(data);
                        },
                        child: MyStyles.myCard(
                          data.name, 
                          ['durasi : ${data.duration.toString() }',
                            'Dimulai : ${data.startedAt ?? 'Belum diketahui'}',
                            'Direncankan : ${data.scheduledAt ?? '?'}'
                          ], 
                          [], 
                          []
                        ),
                      );
                    }
                  ),
                )
              )
            ],
          ),
          ),
        )
         
      ),
    );
  }
}