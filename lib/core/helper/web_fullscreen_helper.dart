// web_fullscreen_helper.dart
import 'dart:js' as js;

class WebFullscreenHelper {
  static void enterFullScreen() {
    try {
      js.context.callMethod('eval', ['''
        const elem = document.documentElement;
        if (elem.requestFullscreen) {
          elem.requestFullscreen();
        } else if (elem.webkitRequestFullscreen) {
          elem.webkitRequestFullscreen();
        } else if (elem.mozRequestFullScreen) {
          elem.mozRequestFullScreen();
        } else if (elem.msRequestFullscreen) {
          elem.msRequestFullscreen();
        }
        
        // Lock orientation to portrait if on mobile
        if (screen.orientation && screen.orientation.lock) {
          screen.orientation.lock('portrait').catch(() => {});
        }
        
        // Hide browser UI on mobile
        if (window.navigator.standalone !== undefined) {
          document.body.style.height = '100vh';
          document.body.style.overflow = 'hidden';
        }
        
        // Add fullscreen styles
        document.body.classList.add('exam-fullscreen');
      ''']);
    } catch (e) {
      print('Error entering fullscreen: $e');
    }
  }

  static void exitFullScreen() {
    try {
      js.context.callMethod('eval', ['''
        if (document.exitFullscreen) {
          document.exitFullscreen();
        } else if (document.webkitExitFullscreen) {
          document.webkitExitFullscreen();
        } else if (document.mozCancelFullScreen) {
          document.mozCancelFullScreen();
        } else if (document.msExitFullscreen) {
          document.msExitFullscreen();
        }
        
        // Remove fullscreen styles
        document.body.classList.remove('exam-fullscreen');
        document.body.style.height = '';
        document.body.style.overflow = '';
      ''']);
    } catch (e) {
      print('Error exiting fullscreen: $e');
    }
  }

  static bool isFullScreen() {
    try {
      final result = js.context.callMethod('eval', ['''
        !!(document.fullscreenElement || 
           document.webkitFullscreenElement || 
           document.mozFullScreenElement || 
           document.msFullscreenElement ||
           document.body.classList.contains('exam-fullscreen'))
      ''']);
      return result == true;
    } catch (e) {
      return false;
    }
  }

  static void setupFullscreenListeners(
    Function() onEnterFullscreen,
    Function() onExitFullscreen,
  ) {
    try {
      js.context.callMethod('eval', ['''
        function handleFullscreenChange() {
          const isFullscreen = !!(document.fullscreenElement || 
                                 document.webkitFullscreenElement || 
                                 document.mozFullScreenElement || 
                                 document.msFullscreenElement);
          
          if (isFullscreen) {
            window.flutter_fullscreen_entered();
          } else {
            window.flutter_fullscreen_exited();
          }
        }
        
        document.addEventListener('fullscreenchange', handleFullscreenChange);
        document.addEventListener('webkitfullscreenchange', handleFullscreenChange);
        document.addEventListener('mozfullscreenchange', handleFullscreenChange);
        document.addEventListener('MSFullscreenChange', handleFullscreenChange);
        
        // Handle escape key
        document.addEventListener('keydown', function(e) {
          if (e.key === 'Escape' && (document.fullscreenElement || document.body.classList.contains('exam-fullscreen'))) {
            window.flutter_fullscreen_exited();
          }
        });
      ''']);

      // Set up Flutter callbacks
      js.context['flutter_fullscreen_entered'] = js.allowInterop(() {
        onEnterFullscreen();
      });

      js.context['flutter_fullscreen_exited'] = js.allowInterop(() {
        onExitFullscreen();
      });
    } catch (e) {
      print('Error setting up fullscreen listeners: $e');
    }
  }
}

