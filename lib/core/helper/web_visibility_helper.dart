import 'dart:js' as js;

class WebVisibilityHelper {
  static void initVisibilityListener(
    Function() onHidden,
    Function() onVisible,
  ) {
    try {
      js.context.callMethod('eval', ['''
        function handleVisibilityChange() {
          if (document.hidden || document.webkitHidden || document.msHidden) {
            window.flutter_app_hidden();
          } else {
            window.flutter_app_visible();
          }
        }
        
        // Page Visibility API
        document.addEventListener('visibilitychange', handleVisibilityChange);
        document.addEventListener('webkitvisibilitychange', handleVisibilityChange);
        document.addEventListener('msvisibilitychange', handleVisibilityChange);
        
        // Focus/Blur events
        window.addEventListener('blur', () => {
          setTimeout(() => {
            if (!document.hasFocus()) {
              window.flutter_app_hidden();
            }
          }, 100);
        });
        
        window.addEventListener('focus', () => {
          window.flutter_app_visible();
        });
        
        // Detect tab switching
        document.addEventListener('visibilitychange', () => {
          if (document.visibilityState === 'hidden') {
            window.flutter_app_hidden();
          } else if (document.visibilityState === 'visible') {
            window.flutter_app_visible();
          }
        });
        
        // Detect window minimize/restore
        window.addEventListener('resize', () => {
          if (window.outerHeight === 0 || window.outerWidth === 0) {
            window.flutter_app_hidden();
          }
        });
        
        // Detect browser back/forward
        window.addEventListener('pageshow', (e) => {
          if (e.persisted) {
            window.flutter_app_visible();
          }
        });
        
        window.addEventListener('pagehide', () => {
          window.flutter_app_hidden();
        });
        
        // PWA specific - detect home screen press
        if (window.matchMedia('(display-mode: standalone)').matches) {
          let lastInteraction = Date.now();
          
          document.addEventListener('touchstart', () => {
            lastInteraction = Date.now();
          });
          
          document.addEventListener('click', () => {
            lastInteraction = Date.now();
          });
          
          // Check if app becomes inactive (home button pressed)
          setInterval(() => {
            if (Date.now() - lastInteraction > 5000 && document.hidden) {
              window.flutter_app_hidden();
            }
          }, 1000);
        }
      ''']);

      // Set up Flutter callbacks
      js.context['flutter_app_hidden'] = js.allowInterop(() {
        onHidden();
      });

      js.context['flutter_app_visible'] = js.allowInterop(() {
        onVisible();
      });
    } catch (e) {
      print('Error setting up visibility listener: $e');
    }
  }

  static void setupBackButtonListener(Function() onBackPressed) {
    try {
      js.context.callMethod('eval', ['''
        // Handle browser back button
        history.pushState(null, null, location.href);
        window.addEventListener('popstate', function() {
          history.pushState(null, null, location.href);
          window.flutter_back_pressed();
        });
        
        // Handle escape key as back
        document.addEventListener('keydown', function(e) {
          if (e.key === 'Escape') {
            e.preventDefault();
            window.flutter_back_pressed();
          }
        });
        
        // Handle Android hardware back button in PWA
        if ('serviceWorker' in navigator) {
          document.addEventListener('keydown', function(e) {
            if (e.keyCode === 4) { // Android back button
              e.preventDefault();
              window.flutter_back_pressed();
            }
          });
        }
      ''']);

      js.context['flutter_back_pressed'] = js.allowInterop(() {
        onBackPressed();
      });
    } catch (e) {
      print('Error setting up back button listener: $e');
    }
  }
}
