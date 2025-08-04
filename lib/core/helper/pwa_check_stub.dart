class PwaCheck {
  static bool isInstalledPWA() {
    return true; // Native app, always allow access
  }
  
  static bool isMobileBrowser() {
    return false; // Not a browser on native
  }
  
  static bool shouldShowInstallPrompt() {
    return false; // Never show install prompt on native
  }
}