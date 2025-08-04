import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_exams/core/helper/helper.dart';
import 'package:my_exams/core/style/styles.dart';
import 'package:my_exams/features/exams/presentation/controller/CExams.dart';
import 'package:my_exams/features/student/presentation/controller/Cuexmas.dart';
import 'package:my_exams/features/exams/presentation/widget/editExamMain.dart';
import 'package:my_exams/features/participants/presentation/controller/CParticipant.dart';

class Upexam extends StatefulWidget {
  const Upexam({super.key});

  @override
  State<Upexam> createState() => _UpexamState();
}

class _UpexamState extends State<Upexam> {
  Cuexmas controller = Get.find<Cuexmas>();
  Cexams examControl = Get.find<Cexams>();
  Cparticipant partControl = Get.find<Cparticipant>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      examControl.getDraft();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          examControl.isEdit.value = false;
          partControl.examsId.value = "";
          Get.to(() => Editexammain());
        },
        child: Icon(Icons.add),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Obx(() => Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await examControl.getDraft();
                      },
                      child: examControl.examsDraft.isEmpty
                          ? ListView(
                            physics: AlwaysScrollableScrollPhysics(),
                            children: [
                              SizedBox(height: 200),
                              Center(child: Text('Tidak ada ujian tersedia')),
                            ],
                            )
                          : ListView.builder(
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: examControl.examsDraft.length,
                              itemBuilder: (context, index) {
                                final data = examControl.examsDraft[index];
                                final packageModel = data.packageModel;
                                final examsModel = data.examsModel;
                                if (packageModel == null) {
                                  return SizedBox.shrink();
                                }
                                return InkWell(
                                  onTap: () async{
                                    examControl.isEdit.value = true;
                                    examControl.setExamsEdit(
                                        packageModel, examsModel);
                                    partControl.examsId.value = examsModel.id;
                                    await Get.to(() => Editexammain())?.then((_) {
                                      examControl.getDraft();
                                    });
                                  },
                                  onLongPress: () {
                                    examControl.showPopUpDelete(
                                        examsModel.id, examControl.examsDraft);
                                  },
                                  child: MyStyles.myCard(
                                      examsModel.name,
                                      [
                                        'Nama Paket : ${packageModel.title}',
                                        'Di Buat : ${Helper.toMySQLDateTime(examsModel.createdAt!)}'
                                      ],
                                      [],
                                      []),
                                );
                              },
                            ),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}