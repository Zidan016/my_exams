import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_exams/core/helper/web_helper_stub.dart'
  if (dart.library.html) 'package:my_exams/core/helper/web_helper.dart';
import 'package:my_exams/core/service/LocalService.dart';import 'package:my_exams/core/style/styles.dart';
import 'package:my_exams/features/student/presentation/widget/endStudent.dart';
import 'package:my_exams/features/student/presentation/widget/nowStudent.dart';
import 'package:my_exams/features/student/presentation/widget/upStudent.dart';
import 'package:restart_app/restart_app.dart';

class Mainstudent extends StatefulWidget {
  const Mainstudent({super.key});

  @override
  State<Mainstudent> createState() => _MainstudentState();
}

class _MainstudentState extends State<Mainstudent> with SingleTickerProviderStateMixin{

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }
  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async{
              LocalService pref = LocalService();
              await pref.setRememberMe(false);
              if(kIsWeb){
                reloadPage();
              }else{
                Restart.restartApp(
                  notificationTitle: 'Restarting App',
                  notificationBody: 'Please tap here to open the app again.',);
              }
            },
          )
        ],
      ),

      body: Center(
        child: Padding(padding: EdgeInsets.all(5),
          child: Column(
            children: [
              TabBar(
                controller: tabController,
                tabs: [
                  Padding(padding: EdgeInsets.all(0), child: MyStyles.textLightSmall('Mendatang'),),
                  Padding(padding: EdgeInsets.all(5), child: MyStyles.textLightSmall('Aktif'),),
                  Padding(padding: EdgeInsets.all(5), child: MyStyles.textLightSmall('Berakhir'),),
                ]
              ),
              Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  Upstudent(),
                  Nowstudent(),
                  Endstudent()
                ]
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}