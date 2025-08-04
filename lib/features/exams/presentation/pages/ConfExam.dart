import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_exams/core/helper/helper.dart';
import 'package:my_exams/core/style/styles.dart';
import 'package:my_exams/features/exams/presentation/controller/CExams.dart';

class Confexam extends StatefulWidget {
  const Confexam({super.key});

  @override
  State<Confexam> createState() => _ConfexamState();
}

class _ConfexamState extends State<Confexam> {
  Cexams cexams = Get.find<Cexams>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ujian'),
      ),
      floatingActionButton: MyStyles.myButton(
        'Mulai Ujian', (){
          cexams.showPopUPStart();
        }),
      body: Obx(()=> 
        Center(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                MyStyles.textContentMedium(cexams.mExamActive.value?.examsModel.name ?? ""),
                SizedBox(height: 5,),
                MyStyles.textLightSmall('Paket : ${cexams.mExamActive.value?.packageModel?.title}'),
                SizedBox(height: 5,),
                MyStyles.textLightSmall('Di publish pada : ${Helper.toMySQLDateTime(cexams.mExamActive.value?.examsModel.scheduledAt)}'),
                SizedBox(height: 5,),
                MyStyles.textLightSmall('Partisipasi :'),
                SizedBox(height: 10,),
                Expanded(
                  child: ListView.builder(
                    itemCount: cexams.listParticipant.length,
                    itemBuilder: (context, index){
                      final data = cexams.listParticipant[index];
                      return MyStyles.myCard(
                        data.mUsers.name, 
                        ['Username : ${data.mUsers.username}'], 
                        [], 
                        []
                      );
                    }
                  )
                )
              ],
            ),
          ),
        )),
    );
  }
}