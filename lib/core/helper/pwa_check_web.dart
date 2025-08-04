import 'dart:js' as js;

class PwaCheck {
  static bool isInstalledPWA() {
    try {
      // Check if running as installed PWA
      final isStandalone = js.context.callMethod('eval', [
        'window.matchMedia("(display-mode: standalone)").matches || window.navigator.standalone === true'
      ]);
      
      return isStandalone;
    } catch (e) {
      return true; // If error, allow access
    }
  }
  
  static bool isMobileBrowser() {
    try {
      final isMobile = js.context.callMethod('eval', [
        '/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)'
      ]);
      
      return isMobile;
    } catch (e) {
      return false;
    }
  }
  
  static bool shouldShowInstallPrompt() {
    return isMobileBrowser() && !isInstalledPWA();
  }
}