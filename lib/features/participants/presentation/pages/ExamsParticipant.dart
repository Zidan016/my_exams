import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:my_exams/core/style/styles.dart';
import 'package:my_exams/features/participants/presentation/controller/CParticipant.dart';

class Examsparticipant extends StatefulWidget {
  const Examsparticipant({super.key});

  @override
  State<Examsparticipant> createState() => _ExamsparticipantState();
}

class _ExamsparticipantState extends State<Examsparticipant> {
  Cparticipant controll = Get.find<Cparticipant>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      controll.getUserPart();
      controll.scroll.value.addListener((){
        if(controll.scroll.value.position.pixels >=
          controll.scroll.value.position.maxScrollExtent - 100) {
          controll.loadMore();
        }
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Partisipasi'),),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Obx(()=> Column(
            children: [
              MyStyles.textfield('Cari partisipasi', controll.searchParticipat.value, onChanged: (value) {
                controll.search(value);
              },),
              const SizedBox(height: 5,),
              Expanded(
                child: ListView.builder(
                  controller: controll.scroll.value,
                  itemCount: controll.listPaged.length,
                  itemBuilder: (context, index){
                    final data = controll.listPaged[index];
                    return InkWell(
                      onTap: (){
                        controll.gotoSection(data.mUsers);
                      },
                      child: MyStyles.myCard(
                        data.mUsers.username, 
                        [data.mUsers.name], 
                        [], 
                        []
                      ),
                    );
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