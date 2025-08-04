import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:my_exams/core/helper/install_prompt_screen.dart';
import 'package:my_exams/core/helper/pwa_check.dart';
import 'package:my_exams/core/service/MainBinding.dart';
import 'package:my_exams/core/service/checking.dart';
import 'package:my_exams/core/service/LocalService.dart';
import 'package:my_exams/core/style/tema.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync<LocalService>(() async {
    final local = LocalService();
    await local.init();
    return local;
  });
  EasyLoading.instance
  ..displayDuration = const Duration(milliseconds: 2000)
  ..indicatorType = EasyLoadingIndicatorType.circle
  ..loadingStyle = EasyLoadingStyle.custom
  ..indicatorSize = 45.0
  ..radius = 10.0
  ..progressColor = const Color.fromARGB(255, 255, 255, 255)
  ..backgroundColor = const Color.fromARGB(255, 113, 113, 113).withOpacity(0.5)
  ..indicatorColor = const Color.fromARGB(255, 250, 250, 250)
  ..textColor = const Color.fromARGB(255, 255, 255, 255)
  ..maskColor = Colors.transparent
  ..userInteractions = true
  ..dismissOnTap = false;

  runApp(
    const MainApp()
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      initialBinding: Mainbinding(),
      title: 'Ujian Kuy',
      debugShowCheckedModeBanner: false,
      theme: TemaClass.tema(),
      builder: EasyLoading.init(),
      home: PWAChecker.shouldShowInstallPrompt() 
        ? const InstallPromptScreen()
        : Checking()
    );
  }
}
