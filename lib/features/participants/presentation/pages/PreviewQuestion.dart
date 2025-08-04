import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_exams/core/style/styles.dart';
import 'package:my_exams/features/participants/presentation/controller/Cpreview.dart';

class Previewquestion extends StatefulWidget {
  const Previewquestion({super.key});

  @override
  State<Previewquestion> createState() => _PreviewquestionState();
}

class _PreviewquestionState extends State<Previewquestion> {
  Cpreview controll = Get.find<Cpreview>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      controll.getQuiz();
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
      appBar: AppBar(
        title: Text('Preview'),
      ),
      body: Obx(()=> Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView.builder(
            controller: controll.scroll.value,
            itemCount: controll.listPaged.length,
            itemBuilder: (context, index){
              final data = controll.listPaged[index];
              return MyStyles.previewCard(data, (val){});
            }
          )
        ),
      )),
    );
  }
}