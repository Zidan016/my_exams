import 'package:flutter/material.dart';
import 'package:my_exams/core/style/styles.dart';
import 'package:my_exams/features/exams/presentation/widget/EndExam.dart';
import 'package:my_exams/features/exams/presentation/widget/ActiveExam.dart';
import 'package:my_exams/features/exams/presentation/widget/UpExam.dart';

class Mainexam extends StatefulWidget {
  const Mainexam({super.key});

  @override
  State<Mainexam> createState() => _MainexamState();
}

class _MainexamState extends State<Mainexam> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              TabBar(
                controller: tabController,
                tabs: [
                  MyStyles.textLightSmall('Draft'),
                  MyStyles.textLightSmall('Aktif'),
                  MyStyles.textLightSmall('Berakhir'),
                ]
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    Upexam(),
                    Activeexam(),
                    Endexam()
                  ]
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}