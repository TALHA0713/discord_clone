import 'package:flutter/material.dart';
import 'settings_screen.dart';

class VoiceVideoSettingsScreen extends StatefulWidget {
  const VoiceVideoSettingsScreen({super.key});

  @override
  State<VoiceVideoSettingsScreen> createState() =>
      _VoiceVideoSettingsScreenState();
}

class _VoiceVideoSettingsScreenState extends State<VoiceVideoSettingsScreen> {
  bool autoSensitivity = true;
  double inputSensitivity = 0.4;
  double outputVolume = 0.5;
  double soundboardVolume = 0.75;
  String noiseSuppression = 'krisp';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2F3136),
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
          'Voice & Video',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----------------- INPUT SECTION -----------------
            const SectionTitle(title: 'Input'),

            // Input Mode
            SettingTile(
              label: 'Input Mode',
              value: 'Voice Activity',
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            ),

            // Auto Sensitivity
            SwitchTile(
              label: 'Auto Sensitivity',
              value: autoSensitivity,
              onChanged: (val) => setState(() => autoSensitivity = val),
            ),

            // Input Sensitivity Slider
            const SizedBox(height: 16),
            const Text(
              'Input Sensitivity',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFF4F545C),
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: inputSensitivity,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF3BA55D),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            Slider(
              value: inputSensitivity,
              onChanged: (val) => setState(() => inputSensitivity = val),
              min: 0,
              max: 1,
              activeColor: const Color(0xFF3BA55D),
              inactiveColor: const Color(0xFF4F545C),
            ),
            const SizedBox(height: 4),
            const Text(
              'If the indicator is solid green then this app is transmitting your beautiful voice.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),

            // ----------------- OUTPUT SECTION -----------------
            const SectionTitle(title: 'Output'),

            // Output Volume
            VolumeSlider(
              label: 'Volume',
              value: outputVolume,
              onChanged: (val) => setState(() => outputVolume = val),
            ),
            const SizedBox(height: 8),
            const Text(
              'Need help with voice or video? Check out our troubleshooting guide.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),

            // ----------------- SOUNDBOARD SECTION -----------------
            const SectionTitle(title: 'Soundboard'),

            VolumeSlider(
              label: 'Soundboard Volume',
              value: soundboardVolume,
              onChanged: (val) => setState(() => soundboardVolume = val),
            ),
            const SizedBox(height: 8),
            const Text(
              'Control how loud sounds are for you personally. For more info, click here.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),

            // ----------------- NOISE SUPPRESSION -----------------
            const SectionTitle(title: 'Noise Suppression'),

            NoiseOption(
              title: 'Krisp',
              selected: noiseSuppression == 'krisp',
              onTap: () => setState(() => noiseSuppression = 'krisp'),
            ),
            NoiseOption(
              title: 'Standard',
              selected: noiseSuppression == 'standard',
              onTap: () => setState(() => noiseSuppression = 'standard'),
            ),
            NoiseOption(
              title: 'None',
              selected: noiseSuppression == 'none',
              onTap: () => setState(() => noiseSuppression = 'none'),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ----------------- COMPONENTS -----------------

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Color(0xFF8E9297),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

class SettingTile extends StatelessWidget {
  final String label;
  final String value;
  final Widget? trailing;

  const SettingTile({
    super.key,
    required this.label,
    required this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF40444B))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(color: Color(0xFF8E9297), fontSize: 16),
              ),
              if (trailing != null) const SizedBox(width: 8),
              if (trailing != null) trailing!,
            ],
          ),
        ],
      ),
    );
  }
}

class SwitchTile extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SwitchTile({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SettingTile(
      label: label,
      value: '',
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: const Color(0xFF5865F2),
        inactiveTrackColor: const Color(0xFF4F545C),
      ),
    );
  }
}

class VolumeSlider extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  const VolumeSlider({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.volume_down, color: Colors.grey),
            Expanded(
              child: Slider(
                value: value,
                onChanged: onChanged,
                min: 0,
                max: 1,
                activeColor: const Color(0xFF5865F2),
                inactiveColor: const Color(0xFF4F545C),
              ),
            ),
            const Icon(Icons.volume_up, color: Colors.grey),
          ],
        ),
      ],
    );
  }
}

class NoiseOption extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const NoiseOption({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SettingTile(
      label: title,
      value: '',
      trailing: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            border: Border.all(
              color: selected
                  ? const Color(0xFF5865F2)
                  : const Color(0xFF72767D),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(50),
          ),
          child: selected
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
      ),
    );
  }
}
