import 'package:flutter/material.dart';
import 'package:my_exams/features/dashboard/presentation/widget/awasi.dart';
import 'package:my_exams/features/dashboard/presentation/widget/dashboard.dart';
import 'package:my_exams/core/style/styles.dart';

class Maindash extends StatefulWidget {
  const Maindash({super.key});

  @override
  State<Maindash> createState() => _MaindashState();
}

class _MaindashState extends State<Maindash> with SingleTickerProviderStateMixin {
  late TabController tabControl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabControl = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TabBar(
              controller: tabControl,
              tabs: [
                MyStyles.textLightSmall('Dahsboard'),
                MyStyles.textLightSmall('Awasi Ujian'),
              ]),
            Expanded(
              child: TabBarView(
                controller: tabControl,
                children: [
                  Dashboard(),
                  Awasi()
                ]
              ),
            ),
          ],
        )
      ),
      
    );
  }
}