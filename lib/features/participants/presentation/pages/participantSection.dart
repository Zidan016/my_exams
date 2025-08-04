import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_exams/core/style/styles.dart';
import 'package:my_exams/features/student/presentation/controller/CSection.dart';

class PreviewSection extends StatefulWidget {
  const PreviewSection({super.key});

  @override
  State<PreviewSection> createState() => _PreviewSectionState();
}

class _PreviewSectionState extends State<PreviewSection> {
  Csection controll = Get.find<Csection>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      controll.getSectionPreview();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sesi'),),
      body: Obx(()=> Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(children: [
            MyStyles.textContentMedium('Total Score : ${controll.totalScore.value.toString()}'),
            const SizedBox(height: 5,),
            Expanded(
              child: RefreshIndicator(
                onRefresh: ()async{controll.getSectionPreview();},
                child: ListView.builder(
                itemCount: controll.listSection.length,
                itemBuilder: (context, index){
                  final data = controll.listSection[index];
                  return InkWell(
                    onTap: (){
                      controll.gotoPreview(data);
                    },
                    child: MyStyles.myCard(data.config?? "",
                      ['Score : ${data.score.toString()}'], 
                        [if(controll.isSiswa.value == false) Icons.edit, if(controll.isSiswa.value == false) Icons.refresh],
                      [(){
                        if(controll.isSiswa.value == false){
                          controll.popUpedit(data.id);
                        }
                      },(){
                        if(controll.isSiswa.value == false){
                          controll.fixScore(data);
                        }
                      }]
                      ),
                    );
                }
              ),
              )
            )
          ],)  
        ),
      )),
    );
  }
}