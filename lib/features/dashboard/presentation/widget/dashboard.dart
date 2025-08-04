import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_exams/core/style/styles.dart';
import 'package:my_exams/features/proctors/presentation/controller/CProctor.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Cproctor controll = Get.find<Cproctor>();
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      controll.getDashborad();
      controll.socketDasboard();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => ListView(
        children: [
        Card(
          child: ListTile(
            leading: MyStyles.textHeadlineMedium('Ujian Berlangsung'),
            title: MyStyles.textContentMedium('${controll.exams}'),
          ),
        ),
        Card(
          child: ListTile(
            leading: MyStyles.textHeadlineMedium('Siswa aktif'),
            title: MyStyles.textContentMedium('${controll.active}'),
          ),
        ),
        //   Card(
        // child: ListTile(
        //   leading: MyStyles.textHeadlineMedium('Siswa siap'),
        //   title: MyStyles.textContentMedium('${controll.ready}'),
        // ),
        //   ),
        //   Card(
        // child: ListTile(
        //   leading: MyStyles.textHeadlineMedium('Siswa selesai'),
        //   title: MyStyles.textContentMedium('${controll.finished}'),
        // ),
        //   ),
        ],
      )),
    );
  }
}