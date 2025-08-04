import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_exams/core/helper/helper.dart';
import 'package:my_exams/core/style/styles.dart';
import 'package:my_exams/features/exams/presentation/controller/CExams.dart';

class Endexam extends StatefulWidget {
  const Endexam({super.key});

  @override
  State<Endexam> createState() => _EndexamState();
}

class _EndexamState extends State<Endexam> {
  Cexams controller = Get.find<Cexams>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      controller.getEnd();
      controller.scroll.value.addListener((){
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
      body: Center(
        child: Obx(()=> 
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                MyStyles.textfield('Cari Ujian', controller.cariControl.value, onChanged: (value) {
                  controller.search(value);
                },),
                const SizedBox(height: 5,),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: ()async{await controller.getEnd();},
                    child: controller.listPaged.isEmpty ? MyStyles.textContentMedium('Belum Ada data') : 
                  ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: controller.scroll.value,
                    itemCount: controller.listPaged.length,
                    itemBuilder: (context, index){
                      final data = controller.listPaged[index];
                        return InkWell(
                          onTap: (){
                            controller.gotoExamsParticipants(data);
                          },
                          onLongPress: (){
                          },
                          child: MyStyles.myCard(
                            data.examsModel.name,
                          [
                            'Paket : ${data.packageModel?.title}',
                            'Di Akhiri pada : ${Helper.toMySQLDateTime(data.examsModel.endedAt)}'
                          ], 
                          [], 
                          []
                        ),
                      );
                    }
                  )
                  )
                ),
              ],
            )
          )),
      ),
    );
  }
}