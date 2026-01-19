import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/user_settings_provider.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/neon_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(userSettingsProvider);
    final notifier = ref.read(userSettingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SETTINGS'),
      ),
      body: GradientBackground(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _buildSectionHeader('LANGUAGE'),
            _buildSettingCard(
              title: 'UI Language',
              subtitle: settings.uiLanguage == 'en' ? 'English' : 'العربية',
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Show language picker
              },
            ),
            _buildSettingCard(
              title: 'Default Translation',
              subtitle: 'English → Arabic',
              onTap: () {},
            ),
            
            const SizedBox(height: 32),
            _buildSectionHeader('FEEDBACK & EXPERIENCE'),
            _buildSwitchCard(
              title: 'Sound Effects',
              value: settings.soundsEnabled,
              onChanged: (val) => notifier.toggleSounds(val),
              icon: Icons.volume_up,
            ),
            _buildSwitchCard(
              title: 'Haptic Feedback',
              value: settings.hapticsEnabled,
              onChanged: (val) => notifier.toggleHaptics(val),
              icon: Icons.vibration,
            ),
            _buildSwitchCard(
              title: 'Auto-scroll Subtitles',
              value: settings.autoScroll,
              onChanged: (val) => notifier.toggleAutoScroll(val),
              icon: Icons.history,
            ),
            
            const SizedBox(height: 32),
            _buildSectionHeader('ACCOUNT'),
            _buildSettingCard(
              title: 'Sign Out',
              subtitle: 'Logged in as Guest',
              textColor: NeonColors.error,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title,
        style: NeonTextStyles.labelSmall.copyWith(color: NeonColors.neonPink),
      ),
    );
  }

  Widget _buildSettingCard({
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: NeonCard(
        borderColor: NeonColors.neonCyan.withOpacity(0.3),
        padding: const EdgeInsets.all(20),
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: NeonTextStyles.bodyLarge.copyWith(color: textColor)),
                Text(subtitle, style: NeonTextStyles.bodySmall),
              ],
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchCard({
    required String title,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: NeonCard(
        borderColor: NeonColors.neonPurple.withOpacity(0.3),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: NeonColors.neonPurple),
            const SizedBox(width: 16),
            Expanded(
              child: Text(title, style: NeonTextStyles.bodyLarge),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: NeonColors.neonPurple,
            ),
          ],
        ),
      ),
    );
  }
}
