import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_exams/core/style/styles.dart';
import 'package:my_exams/features/student/presentation/controller/Cuexmas.dart';

class Upstudent extends StatefulWidget {
  const Upstudent({super.key});

  @override
  State<Upstudent> createState() => _UpstudentState();
}

class _UpstudentState extends State<Upstudent> {
  Cuexmas controll = Get.find<Cuexmas>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      controll.getExams();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Column(
        children: [
          // MyStyles.textfield('Cari Ujian', controll.searchFiled.value),
            SizedBox(height: 10,),
            Expanded(
            child: RefreshIndicator(
              onRefresh: () async { await controll.getExams(); },
              child: controll.listUp.isEmpty
              ? ListView(
                physics: AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: 200),
                  Center(child: Text('Tidak ada ujian tersedia')),
                ],
                )
              : ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: controll.listUp.length,
                itemBuilder: (context, index) {
                  final data = controll.listUp[index];
                  return MyStyles.myCard(
                  data.name,
                  [
                    'durasi : ${data.duration.toString()}',
                    'Dimulai : ${data.startedAt ?? 'Belum diketahui'}',
                    'Direncankan : ${data.scheduledAt ?? '?'}'
                  ],
                  [],
                  []
                  );
                }
                ),
            ),
            )
        ],
      )),
    );
  }
}