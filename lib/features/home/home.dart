import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_exams/core/helper/web_helper_stub.dart'
  if (dart.library.html) 'package:my_exams/core/helper/web_helper.dart';
import 'package:my_exams/core/service/LocalService.dart';
import 'package:my_exams/features/attachment/presentation/pages/attachment.dart';
import 'package:my_exams/features/dashboard/presentation/pages/mainDash.dart';
import 'package:my_exams/features/exams/presentation/pages/MainExam.dart';
import 'package:my_exams/features/home/Chome.dart';
import 'package:my_exams/features/package/presentation/pages/mainPaket.dart';
import 'package:my_exams/features/users/presentation/pages/users.dart';
import 'package:restart_app/restart_app.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Chome chome = Get.find<Chome>();
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    Maindash(), Attachment(), Mainexam(), Mainpaket(), Users()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chome.setUI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      drawer: Drawer(
        child: Obx(
          ()=> ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Menu',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    SizedBox(height: 3,),
                    Text(
                      'Hai ${chome.username.value}',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    SizedBox(height: 3,),
                    Text(
                      'Roles : ${chome.role.value}',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                )
              ),

              Visibility(
                child: ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {
                  _onItemTapped(0);
                  Navigator.pop(context);
                },
              ),),
              
              Visibility(
                visible: chome.attachment.value,
                child: ListTile(
                  leading: Icon(Icons.attachment),
                  title: Text('Attachment'),
                  onTap: () {
                    _onItemTapped(1);
                    Navigator.pop(context);
                  },
                ),
              ),
              
              Visibility(
                visible: chome.exam.value,
                child: ListTile(
                  leading: Icon(Icons.manage_history_rounded),
                  title: Text('Kelola Ujian'),
                  onTap: () {
                    _onItemTapped(2);
                    Navigator.pop(context);
                  },
                ),
              ),
              
              Visibility(
                visible: chome.package.value,
                child: ListTile(
                  leading: Icon(Icons.library_books),
                  title: Text('Paket Soal'),
                  onTap: () {
                    _onItemTapped(3);
                    Navigator.pop(context);
                  },
                ),
              ),
              
              Visibility(
                visible: chome.users.value,
                child: ListTile(
                  leading: Icon(Icons.group),
                  title: Text('Kelola Pengguna'),
                  onTap: () {
                    _onItemTapped(4);
                    Navigator.pop(context);
                  },
                ),
              ),

              const SizedBox(height: 15,),
              TextButton(onPressed: () async{
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
              child: Text('Log out', style: TextStyle(color: Colors.red),))

              // ListTile(
              //   leading: Icon(Icons.folder),
              //   title: Text('Nilai Siswa'),
              //   onTap: () {
              //     _onItemTapped(4);
              //     Navigator.pop(context);
              //   },
              // ),
            ],
          ),
        ) 
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}