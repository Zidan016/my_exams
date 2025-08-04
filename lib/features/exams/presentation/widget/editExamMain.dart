import 'package:flutter/material.dart';
import 'package:my_exams/features/exams/presentation/widget/editExam.dart';
import 'package:my_exams/features/exams/presentation/widget/editParticipan.dart';
import 'package:my_exams/core/style/styles.dart';

class Editexammain extends StatefulWidget {
  const Editexammain({super.key});

  @override
  State<Editexammain> createState() => _EditexammainState();
}

class _EditexammainState extends State<Editexammain> with SingleTickerProviderStateMixin {

  late TabController tabControl;

  @override
  void initState() {
    super.initState();
    tabControl = TabController(length: 2, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Ujian'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TabBar(
              controller: tabControl,
              tabs: [
                MyStyles.textLightSmall('Edit Paket'),
                MyStyles.textLightSmall('partisipan')
              ]),
            Expanded(
              child: TabBarView(
                controller: tabControl,
                children: [
                  Editexam(),
                  Editparticipan()
                ]
              ),
            ),
          ],
        )
    ));
  }
}