import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_exams/core/style/styles.dart';
import 'package:my_exams/features/proctors/presentation/controller/CProctor.dart';

class Screenproctor extends StatefulWidget {
  const Screenproctor({super.key});

  @override
  State<Screenproctor> createState() => _ScreenproctorState();
}

class _ScreenproctorState extends State<Screenproctor> {
  Cproctor cproctor = Get.find<Cproctor>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      cproctor.getExamParticipant();
      cproctor.getExamParticipantIO();
    });
  }

  @override
  void dispose() {
    super.dispose();
    cproctor.rep.disconnetExam(cproctor.mExams.value!.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengawas'),
      ),
      body: Obx(() => Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Pengawas',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              ElevatedButton(
                onPressed: () {
                  cproctor.beforeEnd();
                },
                child: const Text('Akhiri Ujian'),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: cproctor.listPrtStudent.length,
                  itemBuilder: (context, index){
                    final prt = cproctor.listPrtStudent[index];
                    return MyStyles.myCard(
                      prt.user.name, 
                      [
                        'username: ${prt.user.username}',
                        (prt.logs?.content ?? 'Belum ada log'),
                        prt.participant.status
                      ], 
                      [
                        Icons.info
                      ], 
                      [(){
                        cproctor.popUpLogs(prt.participant.id, prt.user.username);
                      }]
                    );
                  }
                )
              )
            ],
          ),
        ),
      ),) 
    );
  }
}