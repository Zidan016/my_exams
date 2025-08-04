import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:my_exams/core/helper/web_fullscreen_helper_main.dart';
import 'package:my_exams/core/helper/web_visibility_helper_main.dart';
import 'package:my_exams/core/style/styles.dart';
import 'package:my_exams/features/student/presentation/controller/CStudent.dart';

class Question extends StatefulWidget {
  const Question({super.key});

  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question> with WidgetsBindingObserver {
  Cstudent controll = Get.find<Cstudent>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    controll.setDuration();
    controll.listeningSection();
    controll.getListeningSectionIO();

    if (kIsWeb) {
      controll.enterFullScreen();
      WebFullscreenHelper.setupFullscreenListeners(
        () {
          if (!controll.isFullscreen.value) {
            controll.isFullscreen.value = true;
            controll.updateLogs();
          }
        },
        () {
          if (controll.isFullscreen.value) {
            print('Fullscreen exited (web)');
            controll.exitFullScreen();
          }
        },
      );

      WebVisibilityHelper.initVisibilityListener(
        () {
          print('Aplikasi masuk background (PWA)');
          if (controll.isFullscreen.value) {
            controll.exitFullScreen();
          }
        },
        () {
          print('Aplikasi kembali aktif (PWA)');
        },
      );

      WebVisibilityHelper.setupBackButtonListener(() {
        controll.onWillPop();
      });
    } else {
      controll.enterFullScreen(); // Native (Android/iOS)
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused && controll.isFullscreen.value) {
      print('Home button pressed (app ke background)');
      controll.exitFullScreen();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controll.audioplayers.value.dispose();
    controll.exitFullScreen();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: controll.onWillPop,
      child: Obx(() => Scaffold(
        appBar: controll.isFullscreen.value
            ? null
            : AppBar(
                title: const Text("Soal Ujian"),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.fullscreen),
                    onPressed: controll.enterFullScreen,
                  )
                ],
                automaticallyImplyLeading: false,
              ),

        body: Obx(() => Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
              child: SingleChildScrollView(
                child: controll.soal(),
              ),
              ),
              Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                  Visibility(
                    visible: controll.isItemDuration.value,
                    child: FloatingActionButton(
                    heroTag: 'Akhiri Sesi',
                    onPressed: () {
                      controll.popUpEnd();
                    },
                    tooltip: 'Akhiri Sesi',
                    mini: true,
                    child: Icon(Icons.done_outline_rounded),
                    ),
                  ),
                  Visibility(
                    visible: !controll.isItemDuration.value,
                    child: FloatingActionButton(
                    heroTag: 'lihat',
                    onPressed: () {
                      controll.onPopUp();
                    },
                    tooltip: 'Lihat Soal',
                    mini: true,
                    child: Icon(Icons.visibility),
                    ),
                  ),
                  Visibility(
                    visible: controll.btnPrev.value,
                    child: FloatingActionButton(
                    heroTag: 'sebelumnya',
                    onPressed: () {
                      controll.prevSoal();
                    },
                    tooltip: 'Sebelumnya',
                    mini: true,
                    child: Icon(Icons.arrow_back),
                    ),
                  ),
                  Visibility(
                    visible: controll.btnNext.value,
                    child: FloatingActionButton(
                    heroTag: 'selanjutnya',
                    onPressed: () {
                      controll.nextSoal();
                    },
                    tooltip: 'Selanjutnya',
                    mini: true,
                    child: Icon(Icons.arrow_forward),
                  ),
                  )
                  
                  ],
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.center,
                  child: MyStyles.textLightSmall(
                  'Durasi sesi : ${controll.duration.value} detik',
                  ),
                ),
                ],
              ),
              ),
            ],
          ),
        )),

      )),
    );
  }

}