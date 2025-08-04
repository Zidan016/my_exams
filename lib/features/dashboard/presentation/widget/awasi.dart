import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_exams/features/exams/presentation/controller/CExams.dart';
import 'package:my_exams/features/proctors/presentation/controller/CProctor.dart';
import 'package:my_exams/features/proctors/presentation/pages/ScreenProctor.dart';

class Awasi extends StatefulWidget {
  const Awasi({super.key});

  @override
  State<Awasi> createState() => _AwasiState();
}

class _AwasiState extends State<Awasi> {
  Cexams cexams = Get.find<Cexams>();
  Cproctor cproctor = Get.find<Cproctor>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cexams.getNow();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return ListView.builder(
          itemCount: cexams.examsNow.length,
          itemBuilder: (context, index) {
            final exam = cexams.examsNow[index];
            return Card(
              child: ListTile(
                title: Text(exam.examsModel.name),
                subtitle: Text(exam.examsModel.startedAt.toString()),
                trailing: TextButton(
                  onPressed: (){
                    cproctor.mExams.value = exam.examsModel;
                    Get.to(()=> Screenproctor())?.then((_){
                      cexams.getNow();
                    });
                  }, 
                  child: Text('Awasi'),
                )
              ),
            );
          },
        );
      }),
    );
  }
}