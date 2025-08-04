import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_exams/core/helper/helper.dart';
import 'package:my_exams/core/style/styles.dart';
import 'package:my_exams/features/exams/presentation/controller/CExams.dart';

class Activeexam extends StatefulWidget {
  const Activeexam({super.key});

  @override
  State<Activeexam> createState() => _ActiveexamState();
}

class _ActiveexamState extends State<Activeexam> {
  Cexams controller = Get.find<Cexams>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      controller.getUpComing();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(()=> Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await controller.getUpComing();
                  },
                  child: controller.examsUpcoming.isEmpty 
                  ? ListView(
                    physics: AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(height: 200),
                      Center(child: Text('Tidak ada ujian tersedia')),
                    ],
                    )
                  : 
                  ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: controller.examsUpcoming.length,
                    itemBuilder: (context, index){
                      final data = controller.examsUpcoming[index];
                        return InkWell(
                          onTap: (){
                            controller.UIexamsPublish(data);
                          },
                          onLongPress: (){
                            controller.showPopUpDelete(data.examsModel.id, controller.examsUpcoming);
                          },
                          child: MyStyles.myCard(
                          data.examsModel.name, 
                          [
                            'Paket : ${data.packageModel?.title}',
                            'Di publish pada : ${Helper.toMySQLDateTime(data.examsModel.scheduledAt)}'
                          ], 
                          [], 
                          []
                        ),
                      );
                    }
                  ) 
                )
              )
            ],
          ),
        ),
      )),
    );
  }
}