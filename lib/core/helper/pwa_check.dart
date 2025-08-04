import 'package:my_exams/core/helper/pwa_check_stub.dart'
    if (dart.library.js) 'package:my_exams/core/helper/pwa_check_web.dart';

abstract class PWAChecker {
  static bool isInstalledPWA() => PwaCheck.isInstalledPWA();
  static bool isMobileBrowser() => PwaCheck.isMobileBrowser();
  static bool shouldShowInstallPrompt() => PwaCheck.shouldShowInstallPrompt();
}