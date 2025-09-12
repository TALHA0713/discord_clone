import 'package:flutter/material.dart';
import 'settings_screen.dart';

class AccessibilitySettingsScreen extends StatefulWidget {
  const AccessibilitySettingsScreen({super.key});

  @override
  State<AccessibilitySettingsScreen> createState() =>
      _AccessibilitySettingsScreenState();
}

class _AccessibilitySettingsScreenState
    extends State<AccessibilitySettingsScreen> {
  // Switch states
  bool reducedMotion = false;
  bool autoPlayGifs = true;
  bool playAnimatedEmoji = true;

  // Radio button states for sticker animation
  int selectedStickerOption = 0; // 0 = Always, 1 = On interaction, 2 = Never

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2F3136), // Discord dark background
      appBar: AppBar(
        backgroundColor: const Color(0xFF36393F),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          },
        ),
        title: const Text(
          'Accessibility',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Reduced Motion Section =====
            const _SectionTitle(title: "Reduced Motion"),
            const SizedBox(height: 8),
            Text(
              "Reduce the amount and intensity of animations, hover effects, and other moving effects across the app. "
              "Need help? Check our Help Center for more info!",
              style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            ),
            const SizedBox(height: 12),
            _buildToggleTile(
              title: "Enable Reduced Motion",
              value: reducedMotion,
              onChanged: (val) {
                setState(() {
                  reducedMotion = val;
                });
              },
            ),

            // ===== Images Section =====
            const _SectionTitle(title: "Images"),
            _buildToggleTile(
              title: "Automatically play GIFs when possible.",
              value: autoPlayGifs,
              onChanged: (val) {
                setState(() {
                  autoPlayGifs = val;
                });
              },
            ),
            _buildToggleTile(
              title: "Play animated emoji",
              subtitle: "I want emoji to move and groove.",
              value: playAnimatedEmoji,
              onChanged: (val) {
                setState(() {
                  playAnimatedEmoji = val;
                });
              },
            ),

            // ===== Stickers Section =====
            const _SectionTitle(title: "Stickers"),
            _buildRadioTile(
              title: "Always animate",
              value: 0,
              groupValue: selectedStickerOption,
              onChanged: (val) {
                setState(() {
                  selectedStickerOption = val!;
                });
              },
            ),
            _buildRadioTile(
              title: "Animate on interaction",
              subtitle:
                  "On the desktop client, stickers will animate on hover or focus. "
                  "On mobile clients, stickers will animate on long-press.",
              value: 1,
              groupValue: selectedStickerOption,
              onChanged: (val) {
                setState(() {
                  selectedStickerOption = val!;
                });
              },
            ),
            _buildRadioTile(
              title: "Never animate",
              value: 2,
              groupValue: selectedStickerOption,
              onChanged: (val) {
                setState(() {
                  selectedStickerOption = val!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // ===== Helper Widget: Toggle Row =====
  Widget _buildToggleTile({
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF4B4D55), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: subtitle != null
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                  ),
                ],
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF5865F2), // Discord blue
            inactiveTrackColor: const Color(0xFF72767D),
          ),
        ],
      ),
    );
  }

  // ===== Helper Widget: Radio Row =====
  Widget _buildRadioTile({
    required String title,
    String? subtitle,
    required int value,
    required int groupValue,
    required ValueChanged<int?> onChanged,
  }) {
    final bool isSelected = value == groupValue;

    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFF4B4D55), width: 1),
          ),
        ),
        child: Row(
          crossAxisAlignment: subtitle != null
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF5865F2) // Discord blue
                      : const Color(0xFF72767D),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Color(0xFF5865F2),
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ===== Section Title Widget =====
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 6),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Color(0xFF8E9297),
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
