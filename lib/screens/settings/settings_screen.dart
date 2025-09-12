import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import 'voice_video_settings_screen.dart';
import 'notifications_settings_screen.dart';
import 'text_images_settings_screen.dart';
import 'appearance_settings_screen.dart';
import 'accessibility_settings_screen.dart';
import 'behavior_settings_screen.dart';
import 'language_settings_screen.dart';
import 'activity_status_settings_screen.dart';
import 'change_log_screen.dart';
import 'support_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // App Settings data
    final List<Map<String, dynamic>> appSettings = [
      {"icon": Icons.mic, "label": "Voice & Video", "screen": const VoiceVideoSettingsScreen()},
      {"icon": Icons.notifications, "label": "Notifications", "screen": const NotificationsSettingsScreen()},
      {"icon": Icons.image, "label": "Text & Images", "screen": const TextImagesSettingsScreen()},
      {"icon": Icons.palette, "label": "Appearance", "screen": const AppearanceSettingsScreen()},
      {"icon": Icons.accessibility, "label": "Accessibility", "screen": const AccessibilitySettingsScreen()},
      {"icon": Icons.settings, "label": "Behavior", "screen": const BehaviorSettingsScreen()},
      {"icon": Icons.translate, "label": "Language", "screen": const LanguageSettingsScreen()},
      {"icon": Icons.help_outline, "label": "Activity Status", "screen": const ActivityStatusSettingsScreen()},
    ];

    // App Information data
    final List<Map<String, dynamic>> appInfo = [
      {"icon": Icons.info_outline, "label": "Change Log", "screen": const ChangeLogScreen()},
      {"icon": Icons.help_outline, "label": "Support", "screen": const SupportScreen()},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF2F3136), // Discord dark background
      appBar: AppBar(
        backgroundColor: const Color(0xFF36393F),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section title
              const Padding(
                padding: EdgeInsets.only(left: 12, bottom: 6),
                child: Text(
                  "App Settings",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9CA3AF), // Tailwind gray-400
                    letterSpacing: 1.2,
                  ),
                ),
              ),

              // App Settings List
              ListView.builder(
                itemCount: appSettings.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final setting = appSettings[index];
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      leading: Icon(setting['icon'], color: Colors.grey[300]),
                      title: Text(
                        setting['label'],
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => setting['screen'],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // App Info Section
              const Padding(
                padding: EdgeInsets.only(left: 12, bottom: 6),
                child: Text(
                  "App Information - 77.3 - Beta (77103)",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9CA3AF),
                    letterSpacing: 1.2,
                  ),
                ),
              ),

              // App Info List
              ListView.builder(
                itemCount: appInfo.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final info = appInfo[index];
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      leading: Icon(info['icon'], color: Colors.grey[300]),
                      title: Text(
                        info['label'],
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => info['screen'],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
