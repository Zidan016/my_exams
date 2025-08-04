import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_exams/core/style/styles.dart';
import 'package:my_exams/features/student/presentation/controller/Cuexmas.dart';

class Nowstudent extends StatefulWidget {
  const Nowstudent({super.key});

  @override
  State<Nowstudent> createState() => _NowstudentState();
}

class _NowstudentState extends State<Nowstudent> {
  Cuexmas controll = Get.find<Cuexmas>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controll.getNow();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:Obx(()=>  Column(
          children: [
            // MyStyles.textfield('Cari Ujian', controll.searchFiled.value),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: RefreshIndicator(
              onRefresh: () async { await controll.getNow(); },
              child: controll.listNow.isEmpty
                ? ListView(
                physics: AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: 200),
                  Center(child: Text('Tidak ada ujian tersedia')),
                ],
                )
                : ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: controll.listNow.length,
                  itemBuilder: (context, index) {
                    final data = controll.listNow[index];
                    return InkWell(
                    onTap: () {
                      controll.getSection(data);
                    },
                    child: MyStyles.myCard(data.name, [
                      'durasi : ${data.duration.toString()}',
                      'Dimulai : ${data.startedAt ?? 'Belum diketahui'}',
                      'Direncankan : ${data.scheduledAt ?? '?'}'
                    ], [], []
                    )
                    );
                  }
                  ),
              ),
            )
          ],
        ),)
      ),
    );
  }
}
