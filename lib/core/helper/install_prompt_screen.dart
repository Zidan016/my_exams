import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class InstallPromptScreen extends StatelessWidget {
  const InstallPromptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.install_mobile,
                size: 80,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 24),
              Text(
                'Install Aplikasi',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Untuk pengalaman terbaik, silakan install aplikasi ke homescreen perangkat Anda.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cara Install:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Android: Menu browser (⋮) → "Add to Home screen"',
                      style: TextStyle(color: Colors.blue.shade600),
                    ),
                    Text(
                      '• iPhone: Share (↗) → "Add to Home Screen"',
                      style: TextStyle(color: Colors.blue.shade600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (kIsWeb)
                ElevatedButton.icon(
                  onPressed: () => _showRefreshDialog(context),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Sudah Install? Refresh'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                )
              else
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Kembali'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRefreshDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Refresh Halaman'),
          content: const Text(
            'Silakan refresh halaman browser Anda secara manual dengan:\n\n'
            '• Tekan F5 pada keyboard\n'
            '• Atau klik tombol refresh di browser\n'
            '• Atau tekan Ctrl+R',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}