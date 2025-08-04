import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:my_exams/core/helper/helper.dart';
import 'package:my_exams/core/style/styles.dart';
import 'package:my_exams/features/student/presentation/controller/CSection.dart';

class Sectionstudent extends StatefulWidget {
  const Sectionstudent({super.key});

  @override
  State<Sectionstudent> createState() => _SectionstudentState();
}

class _SectionstudentState extends State<Sectionstudent> {
  Csection control = Get.find<Csection>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sesi'),
      ),
      body: Obx(()=> 
        Center(
        child: Padding(
          padding: EdgeInsets.all(10),
            child: RefreshIndicator(
              onRefresh: ()async{await control.getSection();},
              child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: control.listSection.length,
              itemBuilder: (contenxt, index){
                final data = control.listSection[index];
                return InkWell(
                  onTap: (){
                    control.getSectionItemAnswer(data);
                  },
                  child: MyStyles.myCard(
                    data.config ?? "Tidak ada config", 
                    ['Terakhir jawab : ${Helper.toMySQLDateTime(data.lastAttemptedAt)}'], 
                    [], 
                    []),
                );
              }
            ),
            )
          ),
        ),
      ),
      
    );
  }
}